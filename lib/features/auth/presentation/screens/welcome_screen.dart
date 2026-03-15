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

              // TuneLetter logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.cassetteBrown,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryText.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.music_note_rounded,
                  size: 60,
                  color: AppColors.accent,
                ),
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
                onPressed: () => context.go('/login'),
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
