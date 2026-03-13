import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../data/services/api_service.dart';

class ReplyFlowScreen extends ConsumerStatefulWidget {
  final String cassetteId;

  const ReplyFlowScreen({super.key, required this.cassetteId});

  @override
  ConsumerState<ReplyFlowScreen> createState() => _ReplyFlowScreenState();
}

class _ReplyFlowScreenState extends ConsumerState<ReplyFlowScreen> {
  int _currentStep = 0;
  final _youtubeLinkController = TextEditingController();
  final _replyTextController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _youtubeLinkController.dispose();
    _replyTextController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _handleSendReply();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _handleSendReply() async {
    setState(() => _isLoading = true);

    try {
      final apiService = ref.read(apiServiceProvider);

      await apiService.createReply(
        cassetteId: widget.cassetteId,
        youtubeUrl: _youtubeLinkController.text.trim(),
        replyText: _replyTextController.text.trim(),
      );

      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.show(context, 'Reply sent! 🎵');
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.show(
          context,
          'Failed to send reply. Please try again.',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (context.canPop())
              context.pop();
            else
              context.go('/');
          },
        ),
        title: Text('Reply (${_currentStep + 1}/3)'),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: AppColors.cream,
            color: AppColors.accent,
          ),

          // Original cassette summary
          Container(
            margin: const EdgeInsets.all(AppSpacing.lg),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.album, color: AppColors.amberAccent),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Replying to cassette',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Share your song back',
                        style: AppTypography.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: _buildStepContent(),
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.softShadow,
                  offset: Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: SecondaryButton(
                      text: 'Back',
                      onPressed: _previousStep,
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text: _currentStep == 2 ? 'Send Reply' : 'Continue',
                    onPressed: _nextStep,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send them a song back', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _youtubeLinkController,
              decoration: const InputDecoration(
                labelText: 'YouTube Link',
                hintText: 'https://youtube.com/watch?v=...',
              ),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Write your reply', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),
            TextFormField(
              controller: _replyTextController,
              maxLines: 6,
              maxLength: 300,
              decoration: const InputDecoration(
                labelText: 'Your Reply',
                hintText: 'Your message...',
                alignLabelWithHint: true,
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preview your reply', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBrown.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.music_note, color: AppColors.amberAccent),
                  const SizedBox(height: AppSpacing.md),
                  Text(_replyTextController.text, style: AppTypography.body),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }
}
