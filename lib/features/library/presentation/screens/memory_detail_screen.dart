import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/cassette_widgets.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../data/services/api_service.dart';
import '../../../home/presentation/widgets/cassette_player_widget.dart';
import '../../../../data/models/cassette.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../unlock/presentation/widgets/login_prompt_modal.dart';

class MemoryDetailScreen extends ConsumerStatefulWidget {
  final String memoryId;

  const MemoryDetailScreen({super.key, required this.memoryId});

  @override
  ConsumerState<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends ConsumerState<MemoryDetailScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  Map<String, dynamic>? _cassetteData;
  List<dynamic> _replies = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _openInYouTube(String videoId) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        AppToast.show(context, 'Cannot open YouTube', isError: true);
      }
    } catch (e) {
      debugPrint('Error launching YouTube: $e');
      AppToast.show(context, 'Failed to open YouTube', isError: true);
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = ref.read(apiServiceProvider);

      // Fetch cassette and replies in parallel
      final results = await Future.wait([
        apiService.getCassetteById(widget.memoryId),
        apiService.getReplies(widget.memoryId),
      ]);

      final cassetteResponse = results[0];
      final repliesResponse = results[1];

      debugPrint(
          'getCassetteById response status: ${cassetteResponse.statusCode}');
      debugPrint('getCassetteById response data: ${cassetteResponse.data}');

      if (cassetteResponse.data == null ||
          (cassetteResponse.data as Map).isEmpty) {
        throw Exception('Cassette data empty');
      }

      setState(() {
        _cassetteData = cassetteResponse.data;
        _replies = (repliesResponse.data['items'] ?? []) as List;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading memory detail: $e');
      String message = 'Failed to load cassette details';
      // Try to extract Dio error details
      try {
        if (e is Exception) message = e.toString();
      } catch (_) {}

      setState(() {
        _errorMessage = message;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSaveCassette() async {
    // Check if user is logged in
    final authState = ref.read(authProvider);

    if (!authState.isAuthenticated) {
      // Show login prompt
      final shouldLogin = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const LoginPromptModal(
          title: 'Save to Library',
          message: 'Create an account to save cassettes to your library',
        ),
      );

      if (shouldLogin == true && mounted) {
        context.push('/login');
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.saveCassette(widget.memoryId);

      if (!mounted) return;

      AppToast.show(context, 'Saved to Library! 💾');
    } catch (e) {
      debugPrint('Error saving cassette: $e');

      if (!mounted) return;

      AppToast.show(
        context,
        'Failed to save cassette',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  EmotionTag _parseEmotionTag(String? tag) {
    switch (tag?.toLowerCase()) {
      case 'joyful':
        return EmotionTag.joyful;
      case 'melancholic':
        return EmotionTag.melancholic;
      case 'nostalgic':
        return EmotionTag.nostalgic;
      case 'hopeful':
        return EmotionTag.hopeful;
      case 'romantic':
        return EmotionTag.romantic;
      case 'bittersweet':
        return EmotionTag.bittersweet;
      case 'peaceful':
        return EmotionTag.peaceful;
      case 'energetic':
        return EmotionTag.energetic;
      default:
        return EmotionTag.joyful;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _cassetteData == null) {
      return Scaffold(
        body: ErrorState(
          message: _errorMessage ?? 'Something went wrong',
          onRetry: _loadData,
        ),
      );
    }

    final emotionTag = _parseEmotionTag(_cassetteData!['emotionTag']);
    final senderName = _cassetteData!['senderName'] ?? 'Anonymous';
    final isAnonymous = _cassetteData!['senderIsAnonymous'] ?? true;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cassette Icon & YouTube Button
            if (_cassetteData!['youtubeVideoId'] != null) ...[
              const SizedBox(height: AppSpacing.xl),

              // Cassette Icon with Emotion Emoji
              Center(
                child: Column(
                  children: [
                    const CassettePlayerWidget(
                      size: 240,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      _cassetteData!['emotionEmoji'] ?? '🎵',
                      style: const TextStyle(fontSize: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // YouTube Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _openInYouTube(_cassetteData!['youtubeVideoId']),
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
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLarge),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Letter
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
              ),
              child: Text(
                _cassetteData!['letterText'] ?? 'No letter',
                style: AppTypography.handwritten,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Metadata
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      EmotionChip(
                        emotion: emotionTag.toString().split('.').last,
                        isSelected: false,
                        small: true,
                      ),
                      const Spacer(),
                      Text(
                        isAnonymous ? 'Anonymous' : 'From $senderName',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Replies section
            if (_replies.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxxl),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  'Conversation (${_replies.length})',
                  style: AppTypography.h3,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._replies.map(
                (reply) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.sm,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMedium,
                      ),
                      border: Border.all(color: AppColors.greyMedium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.music_note, size: 16),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              reply['senderName'] ?? 'Anonymous',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          reply['replyText'] ?? '',
                          style: AppTypography.bodySmall,
                        ),
                        if (reply['youtubeVideoId'] != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          // Thumbnail with clear play overlay
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: GestureDetector(
                              onTap: () =>
                                  _openInYouTube(reply['youtubeVideoId']),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.cream,
                                      borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusSmall),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          reply['thumbnailUrl'] ??
                                              'https://img.youtube.com/vi/${reply['youtubeVideoId']}/hqdefault.jpg',
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Semi-transparent circular play button
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: const BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Explicit action buttons as fallback
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _openInYouTube(reply['youtubeVideoId']),
                                icon: const Icon(Icons.play_arrow, size: 18),
                                label: const Text('Watch in YouTube'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.amberAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    _openInYouTube(reply['youtubeVideoId']),
                                child: const Text('Open in browser'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xxxl),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  PrimaryButton(
                    text: 'Reply with a Song',
                    icon: Icons.reply,
                    onPressed: () => context.push('/reply/${widget.memoryId}'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SecondaryButton(
                    text: 'Save to Library',
                    icon: Icons.favorite_border,
                    onPressed: _isSaving ? null : _handleSaveCassette,
                    isLoading: _isSaving,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
