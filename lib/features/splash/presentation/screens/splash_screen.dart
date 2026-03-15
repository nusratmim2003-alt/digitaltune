import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cassette icon or logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.cassetteBrown,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryText.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note_rounded,
                size: 60,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 32),

            // App name
            Text(
              'TuneLetter',
              style: AppTypography.h1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 8),

            Text(
              'Musical memories that last',
              style: AppTypography.body.copyWith(
                color: AppColors.mutedText,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            // Loading indicator
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
