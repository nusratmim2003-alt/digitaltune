import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Cassette icon/illustration
              Icon(
                Icons.album,
                size: 120,
                color: AppColors.amberAccent.withOpacity(0.8),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Headline
              Text(
                'Send songs like\nhandwritten letters',
                style: AppTypography.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Subheadline
              Text(
                'Share musical moments, wrapped in emotion',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.lightBrown,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // CTAs
              PrimaryButton(
                text: 'Get Started',
                onPressed: () => context.go('/signup'),
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                text: 'I already have an account',
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
