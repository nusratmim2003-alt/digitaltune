import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../home/presentation/widgets/cassette_player_widget.dart';
import '../../domain/providers/shared_cassette_provider.dart';
import '../widgets/login_prompt_modal.dart';

class CassetteExperienceScreen extends ConsumerStatefulWidget {
  final String cassetteId;

  const CassetteExperienceScreen({super.key, required this.cassetteId});

  @override
  ConsumerState<CassetteExperienceScreen> createState() =>
      _CassetteExperienceScreenState();
}

class _CassetteExperienceScreenState
    extends ConsumerState<CassetteExperienceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isSaved = false;
  bool _isSaving = false;
  String? _videoId; // Store video ID for external YouTube link

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Start reveal animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
        _extractVideoId();
      }
    });
  }

  void _extractVideoId() {
    final cassetteState = ref.read(sharedCassetteProvider);
    final cassette = cassetteState.cassette;

    if (cassette != null && cassette.youtubeVideoId.isNotEmpty) {
      // Extract video ID from various YouTube URL formats
      String videoId = cassette.youtubeVideoId;
      debugPrint('Original YouTube value: $videoId');

      // If it's a full embed URL, extract the video ID
      if (videoId.contains('/embed/')) {
        videoId = videoId.split('/embed/').last.split('?').first;
      } else if (videoId.contains('youtube.com/watch')) {
        // Extract from standard YouTube URL: youtube.com/watch?v=VIDEO_ID
        final uri = Uri.parse(videoId);
        videoId = uri.queryParameters['v'] ?? videoId;
      } else if (videoId.contains('youtu.be/')) {
        // Extract from short YouTube URL: youtu.be/VIDEO_ID
        final uri = Uri.parse(videoId);
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : videoId;
        // Remove query parameters if any
        videoId = videoId.split('?').first;
      }
      // If none of the above, assume it's already a video ID

      debugPrint('Extracted video ID: $videoId');

      setState(() {
        _videoId = videoId; // Store for external link
      });
    }
  }

  // Open video in YouTube app or browser
  Future<void> _openInYouTube() async {
    if (_videoId == null) return;

    debugPrint('Attempting to open YouTube video: $_videoId');
    final youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$_videoId');
    debugPrint('YouTube URL: $youtubeUrl');

    try {
      final canLaunch = await canLaunchUrl(youtubeUrl);
      debugPrint('Can launch URL: $canLaunch');

      if (canLaunch) {
        final launched = await launchUrl(
          youtubeUrl,
          mode: LaunchMode
              .externalApplication, // Opens in YouTube app if available
        );
        debugPrint('Launch result: $launched');
      } else {
        if (mounted) {
          AppToast.show(context, 'Cannot open YouTube', isError: true);
        }
      }
    } catch (e) {
      debugPrint('Error launching YouTube: $e');
      if (mounted) {
        AppToast.show(context, 'Failed to open YouTube: $e', isError: true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final authState = ref.read(authProvider);

    // Check if user is logged in
    if (!authState.isAuthenticated) {
      // Show login prompt
      final shouldLogin = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const LoginPromptModal(
          title: 'Save this Memory',
          message: 'Create an account to save this cassette to your library',
        ),
      );

      if (shouldLogin == true && mounted) {
        final from = Uri.encodeComponent('/cassette/${widget.cassetteId}');
        context.push('/login?from=$from');
      }
      return;
    }

    // User is logged in, save cassette
    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(sharedCassetteProvider.notifier);
      final success = await notifier.saveCassette(authState.user!.id);

      if (mounted) {
        if (success) {
          setState(() {
            _isSaved = true;
            _isSaving = false;
          });
          AppToast.show(context, 'Saved to your library');
        } else {
          setState(() => _isSaving = false);
          AppToast.show(context, 'Failed to save cassette', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        AppToast.show(context, 'Failed to save cassette', isError: true);
      }
    }
  }

  Future<void> _handleReply() async {
    final authState = ref.read(authProvider);
    final cassetteState = ref.read(sharedCassetteProvider);
    final cassette = cassetteState.cassette;

    if (cassette == null) {
      AppToast.show(context, 'Cassette not found', isError: true);
      return;
    }

    // Check if user is logged in
    if (!authState.isAuthenticated) {
      // Show login prompt
      final shouldLogin = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const LoginPromptModal(
          title: 'Reply to this Cassette',
          message: 'Create an account to send a cassette in return',
        ),
      );

      if (shouldLogin == true && mounted) {
        final from = Uri.encodeComponent('/cassette/${widget.cassetteId}');
        context.push('/login?from=$from');
      }
      return;
    }

    // User is logged in, navigate to reply flow with actual cassette ID
    context.push('/reply/${cassette.id}');
  }

  @override
  Widget build(BuildContext context) {
    final cassetteState = ref.watch(sharedCassetteProvider);
    final cassette = cassetteState.cassette;

    if (cassette == null) {
      return Scaffold(
        body: SafeArea(
          child: ErrorState(
            message: 'Cassette not found',
            onRetry: () => context.go('/'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.deepBrown,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                      ),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Cassette Icon & YouTube Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // Cassette Icon with Emotion Emoji
                    Center(
                      child: Column(
                        children: [
                          const CassettePlayerWidget(size: 240),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            cassette.emotionEmoji,
                            style: const TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // YouTube Button
                    ElevatedButton.icon(
                      onPressed: _openInYouTube,
                      icon: const Icon(Icons.play_circle_filled, size: 28),
                      label: const Text(
                        'Watch in YouTube',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amberAccent,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.lg,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMedium,
                          ),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Cassette Details
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      // Emotion tag above the letter card
                      Text(
                        cassette.emotionTag.toUpperCase(),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Letter card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: AppColors.reelBrown.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLarge,
                          ),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cassette.letterText,
                              style: AppTypography.handwrittenLarge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                height: 1.8,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '— ${cassette.displaySenderName}',
                                style: AppTypography.handwritten.copyWith(
                                  color: AppColors.accent,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Save button
                      SecondaryButton(
                        text: _isSaved
                            ? '✓ Saved to Library'
                            : '💾 Save to Library',
                        onPressed: _isSaved ? null : _handleSave,
                        isLoading: _isSaving,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Reply button
                      PrimaryButton(
                        text: '💬  Reply with a Cassette',
                        onPressed: _handleReply,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Create your own CTA
                      TextButton(
                        onPressed: () => context.go('/create-cassette'),
                        child: const Text(
                          'Create your own cassette →',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
