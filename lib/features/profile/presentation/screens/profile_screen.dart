import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../library/domain/providers/library_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfileStats();
  }

  Future<void> _loadProfileStats() async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) return;

    final notifier = ref.read(libraryProvider.notifier);
    await notifier.fetchSentCassettes();
    await notifier.fetchSavedCassettes();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final libraryState = ref.watch(libraryProvider);
    final user = authState.user;
    final sent = libraryState.sentCassettes.length;
    final saved = libraryState.savedCassettes.length;
    final replies = libraryState.sentCassettes.fold<int>(
      0,
      (sum, cassette) => sum + cassette.replyCount,
    );

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please log in to view your profile',
                  style: AppTypography.body,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
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
                  _buildStat('Replies', '$replies'),
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
        content: Text(
          'Are you sure you want to log out?',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedText)),
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
