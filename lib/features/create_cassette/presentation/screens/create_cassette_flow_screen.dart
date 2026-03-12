import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/cassette_widgets.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../data/models/cassette.dart';
import '../../../../data/services/api_service.dart';

class CreateCassetteFlowScreen extends ConsumerStatefulWidget {
  const CreateCassetteFlowScreen({super.key});

  @override
  ConsumerState<CreateCassetteFlowScreen> createState() =>
      _CreateCassetteFlowScreenState();
}

class _CreateCassetteFlowScreenState
    extends ConsumerState<CreateCassetteFlowScreen> {
  int _currentStep = 0;

  final _youtubeLinkController = TextEditingController();
  final _letterController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _photoPath;
  EmotionTag? _selectedEmotion;
  bool _isAnonymous = false;
  bool _isLoading = false;
  String? _shareUrl;
  String? _shareCode;

  String _getEmotionEmoji(EmotionTag tag) {
    switch (tag) {
      case EmotionTag.joyful:
        return '😊';
      case EmotionTag.melancholic:
        return '😢';
      case EmotionTag.nostalgic:
        return '🌅';
      case EmotionTag.hopeful:
        return '🌟';
      case EmotionTag.romantic:
        return '💕';
      case EmotionTag.bittersweet:
        return '🥲';
      case EmotionTag.peaceful:
        return '🕊️';
      case EmotionTag.energetic:
        return '⚡';
    }
  }

  String _getEmotionTagString(EmotionTag tag) {
    switch (tag) {
      case EmotionTag.joyful:
        return 'Joyful';
      case EmotionTag.melancholic:
        return 'Melancholic';
      case EmotionTag.nostalgic:
        return 'Nostalgic';
      case EmotionTag.hopeful:
        return 'Hopeful';
      case EmotionTag.romantic:
        return 'Romantic';
      case EmotionTag.bittersweet:
        return 'Bittersweet';
      case EmotionTag.peaceful:
        return 'Peaceful';
      case EmotionTag.energetic:
        return 'Energetic';
    }
  }

  String _getEmotionDisplayName(EmotionTag tag) {
    switch (tag) {
      case EmotionTag.joyful:
        return 'Joyful';
      case EmotionTag.melancholic:
        return 'Melancholic';
      case EmotionTag.nostalgic:
        return 'Nostalgic';
      case EmotionTag.hopeful:
        return 'Hopeful';
      case EmotionTag.romantic:
        return 'Romantic';
      case EmotionTag.bittersweet:
        return 'Bittersweet';
      case EmotionTag.peaceful:
        return 'Peaceful';
      case EmotionTag.energetic:
        return 'Energetic';
    }
  }

  @override
  void dispose() {
    _youtubeLinkController.dispose();
    _letterController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
    } else {
      _handleGenerate();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _handleGenerate() async {
    if (_selectedEmotion == null) {
      AppToast.show(context, 'Please select an emotion.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ref.read(apiServiceProvider);

      final response = await apiService.createCassette(
        youtubeUrl: _youtubeLinkController.text.trim(),
        letterText: _letterController.text.trim(),
        emotionTag: _getEmotionTagString(_selectedEmotion!),
        password: _passwordController.text,
        senderIsAnonymous: _isAnonymous,
        coverImageUrl: _photoPath,
      );

      final data = response.data;
      debugPrint('Create cassette response: $data');

      final cassette = data['cassette'];

      if (cassette == null) {
        throw Exception('Cassette object missing in response');
      }

      final shareUrl = cassette['shareUrl'];
      final shareCode = cassette['shareCode'];

      if (shareUrl == null || shareCode == null) {
        throw Exception('shareUrl or shareCode missing in response');
      }

      if (!mounted) return;

      setState(() {
        _shareUrl = shareUrl.toString();
        _shareCode = shareCode.toString();
        _isLoading = false;
      });

      _showSuccessDialog();
    } catch (e) {
      debugPrint('Error creating cassette: $e');

      if (!mounted) return;

      setState(() => _isLoading = false);

      AppToast.show(
        context,
        'Failed to create cassette. Please try again.',
        isError: true,
      );
    }
  }

  void _showSuccessDialog() {
    if (_shareUrl == null || _shareCode == null) {
      AppToast.show(
        context,
        'Failed to generate a valid share link.',
        isError: true,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Your cassette is ready!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shareable Link:'),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: SelectableText(
                _shareUrl!,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Share Code: $_shareCode',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Password: ${_passwordController.text}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              context.go('/');
            },
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.push('/unlock/$_shareCode');
            },
            child: const Text('Test Unlock'),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: _shareUrl!),
              );
              AppToast.show(context, 'Link copied!');
            },
            child: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text('Create Cassette (${_currentStep + 1}/6)'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 6,
              backgroundColor: AppColors.cream,
              valueColor: const AlwaysStoppedAnimation(AppColors.amberAccent),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - AppSpacing.xl * 2,
                      ),
                      child: _buildStepContent(),
                    ),
                  );
                },
              ),
            ),
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
                      text: _currentStep == 5 ? 'Generate Link' : 'Continue',
                      onPressed: _canProceed() ? _nextStep : null,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _youtubeLinkController.text.trim().isNotEmpty;
      case 1:
        return _letterController.text.trim().isNotEmpty;
      case 2:
        return true;
      case 3:
        return _selectedEmotion != null;
      case 4:
        return _passwordController.text.isNotEmpty &&
            _confirmPasswordController.text.isNotEmpty &&
            _passwordController.text == _confirmPasswordController.text;
      case 5:
        return true;
      default:
        return false;
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      case 4:
        return _buildStep5();
      case 5:
        return _buildStep6();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What song will you send?', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Paste a YouTube link below',
          style: AppTypography.body.copyWith(color: AppColors.lightBrown),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextFormField(
          controller: _youtubeLinkController,
          decoration: const InputDecoration(
            labelText: 'YouTube Link',
            hintText: 'https://youtube.com/watch?v=...',
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'e.g., https://youtu.be/dQw4w9WgXcQ',
          style: AppTypography.caption,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Write your letter', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Say what the song means to you',
          style: AppTypography.body.copyWith(color: AppColors.lightBrown),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextFormField(
          controller: _letterController,
          maxLines: 8,
          maxLength: 500,
          decoration: const InputDecoration(
            labelText: 'Your Letter',
            hintText: 'Dear...',
            alignLabelWithHint: true,
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add a photo (optional)', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'A picture to go with your memory',
          style: AppTypography.body.copyWith(color: AppColors.lightBrown),
        ),
        const SizedBox(height: AppSpacing.xl),
        GestureDetector(
          onTap: () {
            AppToast.show(context, 'Image picker coming soon!');
          },
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: AppColors.greyMedium,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 48, color: AppColors.lightBrown),
                  SizedBox(height: AppSpacing.sm),
                  Text('Tap to add photo'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What emotion does this carry?', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Choose one',
          style: AppTypography.body.copyWith(color: AppColors.lightBrown),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: EmotionTag.values.map((tag) {
            return EmotionChip(
              emotion: _getEmotionDisplayName(tag),
              isSelected: _selectedEmotion == tag,
              onTap: () => setState(() => _selectedEmotion = tag),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Protect this memory', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Create a password to unlock this cassette',
          style: AppTypography.body.copyWith(color: AppColors.lightBrown),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter password',
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Re-enter password',
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.xl),
        SwitchListTile(
          title: const Text('Send anonymously'),
          subtitle: const Text('Your name won\'t appear on the cassette'),
          value: _isAnonymous,
          onChanged: (value) => setState(() => _isAnonymous = value),
          activeColor: AppColors.amberAccent,
        ),
      ],
    );
  }

  Widget _buildStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preview your cassette', style: AppTypography.h2),
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
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedEmotion != null)
                        Text(
                          _getEmotionEmoji(_selectedEmotion!),
                          style: const TextStyle(fontSize: 48),
                        )
                      else
                        const Icon(
                          Icons.music_note,
                          size: 64,
                          color: AppColors.lightBrown,
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Your Cassette',
                        style: AppTypography.body.copyWith(
                          color: AppColors.lightBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _letterController.text,
                style: AppTypography.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_selectedEmotion != null)
                EmotionChip(
                  emotion: _getEmotionDisplayName(_selectedEmotion!),
                  isSelected: false,
                  small: true,
                ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _isAnonymous ? 'Anonymous' : 'From: You',
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
