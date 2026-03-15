import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';

class LoginPromptModal extends StatelessWidget {
  final String title;
  final String message;

  const LoginPromptModal({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusXLarge),
          topRight: Radius.circular(AppSpacing.radiusXLarge),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppSpacing.xl,
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 32,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            title,
            style: AppTypography.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          // Message
          Text(
            message,
            style: AppTypography.body.copyWith(
              color: AppColors.mutedText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Buttons
          PrimaryButton(
            text: 'Sign Up',
            onPressed: () {
              context.pop(true);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            text: 'Log In',
            onPressed: () {
              context.pop(true);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text(
              'Maybe Later',
              style: TextStyle(
                color: AppColors.mutedText,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
