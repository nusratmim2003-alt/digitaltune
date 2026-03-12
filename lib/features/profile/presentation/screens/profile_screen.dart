import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../data/services/mock_data_service.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mockService = ref.watch(mockDataServiceProvider);
    final user = mockService.mockUser;
    final sent = mockService.getMockSentCassettes().length;
    final saved = mockService.getMockSavedCassettes().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),

            // Profile photo
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.cream,
              child: Text(
                user.name[0].toUpperCase(),
                style: AppTypography.h1.copyWith(color: AppColors.amberAccent),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Name
            Text(user.name, style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              user.email,
              style: AppTypography.body.copyWith(color: AppColors.lightBrown),
            ),
            const SizedBox(height: AppSpacing.md),

            // Bio
            if (user.bio != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  user.bio!,
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: AppSpacing.xxxl),

            // Stats
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBrown.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('Sent', '$sent'),
                  Container(width: 1, height: 40, color: AppColors.greyMedium),
                  _buildStat('Replies', '8'),
                  Container(width: 1, height: 40, color: AppColors.greyMedium),
                  _buildStat('Saved', '$saved'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Edit Profile button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: OutlinedButton(
                onPressed: () {
                  AppToast.show(context, 'Edit profile coming soon!');
                },
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: OutlinedButton(
                onPressed: () => _handleLogout(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('Log Out'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paper,
        title: Text('Log Out', style: AppTypography.h3),
        content: Text('Are you sure you want to log out?',
            style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.mutedText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.logout();

      if (context.mounted) {
        AppToast.show(context, 'Logged out successfully');
      }
    }
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.h2.copyWith(color: AppColors.amberAccent),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
