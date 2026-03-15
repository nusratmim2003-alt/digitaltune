import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class CassettePlayerWidget extends StatelessWidget {
  final double size;

  const CassettePlayerWidget({
    super.key,
    this.size = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cassetteBrown,
            AppColors.cassetteBrown.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.cassetteBrown.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: AppColors.accent.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Label area at top
          Positioned(
            top: AppSpacing.lg,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            child: Container(
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: const Center(
                child: Text(
                  'A song for you',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.cassetteBrown,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Cassette reels (circles)
          Positioned(
            bottom: AppSpacing.lg,
            left: size * 0.15,
            child: _buildReel(size * 0.15),
          ),
          Positioned(
            bottom: AppSpacing.lg,
            right: size * 0.15,
            child: _buildReel(size * 0.15),
          ),

          // Accent line
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReel(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.reelBrown,
        border: Border.all(
          color: AppColors.paper.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.3,
          height: size * 0.3,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.vinylBlack,
          ),
        ),
      ),
    );
  }
}
