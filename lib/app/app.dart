import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import '../core/theme/app_theme.dart';
import 'router.dart';

class DigitalCassetteApp extends ConsumerStatefulWidget {
  const DigitalCassetteApp({super.key});

  @override
  ConsumerState<DigitalCassetteApp> createState() => _DigitalCassetteAppState();
}

class _DigitalCassetteAppState extends ConsumerState<DigitalCassetteApp> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Cold start link handling (app closed -> opened by link)
    final initialUri = await _appLinks.getInitialAppLink();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Digital Cassette',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
