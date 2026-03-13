import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import '../core/theme/app_theme.dart';
import '../data/services/api_service.dart';
import 'router.dart';

class DigitalCassetteApp extends ConsumerStatefulWidget {
  const DigitalCassetteApp({super.key});

  @override
  ConsumerState<DigitalCassetteApp> createState() => _DigitalCassetteAppState();
}

class _DigitalCassetteAppState extends ConsumerState<DigitalCassetteApp> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  Timer? _uptimeTimer;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _startUptimePing();
  }

  /// Pings /health immediately, then every 10 minutes so the Render
  /// free-tier instance never idles and causes a cold-start delay.
  void _startUptimePing() {
    _pingServer();
    _uptimeTimer = Timer.periodic(
      const Duration(minutes: 10),
      (_) => _pingServer(),
    );
  }

  void _pingServer() {
    ref.read(apiServiceProvider).pingHealth();
  }

  Future<void> _initDeepLinks() async {
    // Cold start link handling (app closed -> opened by link)
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _navigateFromUri(initialUri);
    }

    // Foreground/background link handling
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _navigateFromUri(uri);
    });
  }

  void _navigateFromUri(Uri uri) {
    String? code;

    // custom scheme: digitalcassette://unlock/ABC123
    if (uri.scheme == 'digitalcassette' && uri.host == 'unlock') {
      code = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    // app link/web link: https://digitalcassette-api.onrender.com/unlock/ABC123
    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments.first == 'unlock') {
      code = uri.pathSegments[1];
    }

    if (code != null && code.isNotEmpty) {
      ref.read(routerProvider).go('/unlock/$code');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _uptimeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'TuneLetter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
