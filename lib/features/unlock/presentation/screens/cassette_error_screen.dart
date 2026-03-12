import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';

class CassetteErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  final bool showBackButton;

  const CassetteErrorScreen({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline,
    this.actionButtonText,
    this.onActionPressed,
    this.showBackButton = true,
  });

  // Factory constructors for common error states
  factory CassetteErrorScreen.notFound(BuildContext context) {
    return CassetteErrorScreen(
      icon: Icons.search_off,
      title: 'Cassette Not Found',
      message:
          'We couldn\'t find this cassette. The link may be invalid or the cassette may have been removed.',
      actionButtonText: 'Explore Digital Cassette',
      onActionPressed: () => context.go('/'),
    );
  }

  factory CassetteErrorScreen.deleted(BuildContext context) {
    return CassetteErrorScreen(
      icon: Icons.delete_outline,
      title: 'Cassette Removed',
      message:
          'This cassette has been removed by the sender. It\'s no longer available.',
      actionButtonText: 'Explore Digital Cassette',
      onActionPressed: () => context.go('/'),
    );
  }

  factory CassetteErrorScreen.expired(BuildContext context) {
    return CassetteErrorScreen(
      icon: Icons.schedule,
      title: 'Cassette Expired',
      message:
          'This cassette has expired and can no longer be opened. The sender set a time limit for this memory.',
      actionButtonText: 'Explore Digital Cassette',
      onActionPressed: () => context.go('/'),
    );
  }

  factory CassetteErrorScreen.maxUnlocksReached(BuildContext context) {
    return CassetteErrorScreen(
      icon: Icons.lock_clock,
      title: 'Unlock Limit Reached',
      message:
          'This cassette has been unlocked the maximum number of times allowed by the sender.',
      actionButtonText: 'Explore Digital Cassette',
      onActionPressed: () => context.go('/'),
    );
  }

  factory CassetteErrorScreen.wrongPassword({
    required BuildContext context,
    required int attemptsRemaining,
  }) {
    final isLastAttempt = attemptsRemaining == 1;
    return CassetteErrorScreen(
      icon: Icons.lock_outline,
      title: 'Wrong Password',
      message: isLastAttempt
          ? 'Wrong password. You have 1 attempt remaining before this cassette locks.'
          : 'Wrong password. You have $attemptsRemaining attempts remaining.',
      actionButtonText: 'Try Again',
      onActionPressed: () => context.pop(),
      showBackButton: false,
    );
  }

  factory CassetteErrorScreen.tooManyAttempts(BuildContext context) {
    return CassetteErrorScreen(
      icon: Icons.lock,
      title: 'Too Many Attempts',
      message:
          'You\'ve entered the wrong password too many times. This cassette is temporarily locked. Try again in 30 minutes.',
      actionButtonText: 'Go Home',
      onActionPressed: () => context.go('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: showBackButton
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.border.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 64,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Error title
                Text(
                  title,
                  style: AppTypography.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),

                // Error message
                Text(
                  message,
                  style: AppTypography.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Action button
                if (actionButtonText != null && onActionPressed != null)
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: actionButtonText!,
                      onPressed: onActionPressed,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
