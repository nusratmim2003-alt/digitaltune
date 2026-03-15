import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../widgets/cassette_player_widget.dart';

class LandingHomeScreen extends ConsumerWidget {
  const LandingHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Navigation Bar
            _buildTopNavBar(context, authState.isAuthenticated),

            // Hero Section
            _buildHeroSection(context),

            const SizedBox(height: AppSpacing.xxxl * 2),

            // Emotional Stats Row
            _buildStatsRow(),

            const SizedBox(height: AppSpacing.xxxl * 2),

            // How It Works Section
            _buildHowItWorksSection(),

            const SizedBox(height: AppSpacing.xxxl * 2),

            // Final CTA Section
            _buildFinalCTASection(context),

            const SizedBox(height: AppSpacing.xxxl),

            // Footer
            _buildFooter(),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(BuildContext context, bool isAuthenticated) {
    final isCompact = MediaQuery.of(context).size.width < 380;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.6),
        border: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Logo
            Container(
              width: isCompact ? 30 : 34,
              height: isCompact ? 30 : 34,
              decoration: BoxDecoration(
                color: AppColors.cassetteBrown,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryText.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.music_note_rounded,
                color: AppColors.accent,
                size: isCompact ? 16 : 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'TuneLetter',
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                  fontSize: isCompact ? 13 : 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Library button
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.22),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryText.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () => context.push('/library'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 10 : 12,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.library_music_rounded,
                      color: AppColors.accent,
                      size: isCompact ? 16 : 18,
                    ),
                    if (!isCompact) ...[
                      const SizedBox(width: 6),
                      Text(
                        'Library',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Create Button (highlighted)
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amberAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () => context.push('/create-cassette'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isCompact ? 'New' : 'Create',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: isCompact ? 12 : 13,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Profile/Login Icon
            IconButton(
              icon: const Icon(
                Icons.person_outline,
                color: AppColors.mutedText,
                size: 22,
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () =>
                  context.push(isAuthenticated ? '/profile' : '/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxxl),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.accent.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusCircular),
            ),
            child: Text(
              'A SONG SAYS WHAT WORDS CAN\'T',
              style: AppTypography.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Main Heading
          Text(
            'Send a Song,\nSeal a Memory',
            style: AppTypography.h1.copyWith(fontSize: 42, height: 1.2),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          // Subheading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'Paste a YouTube link, write a letter, and send it to someone special in a nostalgic cassette tape.',
              style: AppTypography.body.copyWith(
                color: AppColors.mutedText,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // Cassette Visual
          const CassettePlayerWidget(size: 300),

          const SizedBox(height: AppSpacing.xxxl),

          // Primary CTA
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Create a Cassette',
              onPressed: () => context.push('/create-cassette'),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Secondary CTA
          SizedBox(
            width: double.infinity,
            child: SecondaryButton(
              text: 'Open a Cassette',
              onPressed: () => _showEnterCodeDialog(context),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_music_rounded,
                size: 16,
                color: AppColors.accent.withOpacity(0.8),
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  'Open your library & see Inbox, Saved, Sent cassettes',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.mutedText,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEnterCodeDialog(BuildContext context) {
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Cassette'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-character share code',
              style: AppTypography.body.copyWith(color: AppColors.mutedText),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: codeController,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Share Code',
                hintText: 'ABC123',
                counterText: '',
              ),
              onChanged: (value) {
                // Auto-uppercase
                if (value != value.toUpperCase()) {
                  codeController.value = codeController.value.copyWith(
                    text: value.toUpperCase(),
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final code = codeController.text.trim();
              if (code.isEmpty) {
                AppToast.show(context, 'Please enter a code', isError: true);
                return;
              }
              if (code.length != 6) {
                AppToast.show(
                  context,
                  'Code must be 6 characters',
                  isError: true,
                );
                return;
              }
              Navigator.of(context).pop();
              context.push('/unlock/$code');
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Songs Sent', '12,847'),
          _buildStatCard('Memories', '8,392'),
          _buildStatCard('Cassettes', '21,239'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h2.copyWith(
            color: AppColors.accent,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.mutedText),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          // Section Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusCircular),
            ),
            child: Text(
              'HOW IT WORKS',
              style: AppTypography.caption.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Heading
          Text(
            'Making Memories,\nOne Song',
            style: AppTypography.h2.copyWith(fontSize: 32),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.sm),

          // Subtitle
          Text(
            'Takes less than a minute',
            style: AppTypography.handwritten.copyWith(color: AppColors.accent),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // Feature Cards Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
            childAspectRatio: 0.62,
            children: [
              _buildFeatureCard(
                '1',
                'Add a Song',
                'Paste a YouTube link that means something',
                Icons.music_note,
              ),
              _buildFeatureCard(
                '2',
                'Write a Letter',
                'Pour your heart out in a personal message',
                Icons.edit_note,
              ),
              _buildFeatureCard(
                '3',
                'Seal with Password',
                'Protect it with a secret only they know',
                Icons.lock_outline,
              ),
              _buildFeatureCard(
                '4',
                'Share the Link',
                'Send a unique link they unlock and feel',
                Icons.share,
              ),
              _buildFeatureCard(
                '5',
                'They Unlock It',
                'The cassette opens and the song begins',
                Icons.lock_open,
              ),
              _buildFeatureCard(
                '6',
                'Get a Reply',
                'They reply with their own song and message',
                Icons.reply,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Icon
          Icon(icon, color: AppColors.primaryText, size: 28),

          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Description
          Expanded(
            child: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.mutedText,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCTASection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: AppColors.white.withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Ready to make\nsomeone\'s day?',
            style: AppTypography.h2.copyWith(
              color: AppColors.white,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'A song, a few words, and a little heart.',
            style: AppTypography.handwritten.copyWith(
              color: AppColors.white.withOpacity(0.9),
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: 220,
            child: ElevatedButton(
              onPressed: () => context.push('/create-cassette'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.amberAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                elevation: 0,
              ),
              child: Text(
                'Create Your First Cassette',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.cassetteBrown.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: AppColors.accent,
                size: 14,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'TuneLetter',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryText.withOpacity(0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Made with love • 2026',
          style: AppTypography.caption.copyWith(
            color: AppColors.mutedText.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
