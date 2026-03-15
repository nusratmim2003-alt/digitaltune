import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cassette.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Cassette card for library grid display
class CassetteCard extends StatelessWidget {
  final Cassette cassette;
  final VoidCallback? onTap;
  final bool showNewBadge;

  const CassetteCard({
    super.key,
    required this.cassette,
    this.onTap,
    this.showNewBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusLarge),
                    topRight: Radius.circular(AppSpacing.radiusLarge),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: cassette.photoUrl != null
                        ? CachedNetworkImage(
                            imageUrl: cassette.photoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.greyLight,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                _buildPlaceholder(),
                          )
                        : cassette.youtubeThumbnail != null
                            ? CachedNetworkImage(
                                imageUrl: cassette.youtubeThumbnail!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: AppColors.greyLight),
                                errorWidget: (context, url, error) =>
                                    _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                  ),
                ),
                if (showNewBadge && !cassette.isRead)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amberAccent,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Letter preview — single line to prevent card overflow
                  Text(
                    cassette.letterText,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Metadata row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cassette.isAnonymous
                              ? 'Anonymous'
                              : cassette.senderName ?? 'Unknown',
                          style: AppTypography.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (cassette.replyCount > 0) ...[
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          Icons.reply,
                          size: AppSpacing.iconSmall,
                          color: AppColors.lightBrown,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${cassette.replyCount}',
                          style: AppTypography.caption,
                        ),
                      ],
                    ],
                  ),

                  // Emotion tag
                  EmotionChip(
                    emotion: cassette.emotionTagName,
                    isSelected: false,
                    small: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cream,
      child: Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.cassetteBrown,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.music_note_rounded,
            size: 34,
            color: AppColors.amberAccent,
          ),
        ),
      ),
    );
  }
}

/// Emotion tag chip
class EmotionChip extends StatelessWidget {
  final String emotion;
  final bool isSelected;
  final bool small;
  final VoidCallback? onTap;

  const EmotionChip({
    super.key,
    required this.emotion,
    required this.isSelected,
    this.small = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getEmotionColor(emotion);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? AppSpacing.sm : AppSpacing.md,
          vertical: small ? AppSpacing.xs : AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.white,
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(small ? 12 : 16),
        ),
        child: Text(
          emotion,
          style: (small ? AppTypography.caption : AppTypography.bodySmall)
              .copyWith(
            color: isSelected ? AppColors.white : color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
