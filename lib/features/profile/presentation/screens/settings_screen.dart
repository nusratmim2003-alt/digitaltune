import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../auth/domain/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _anonymousModeDefault = false;

  Future<void> _handleLogout() async {
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

    if (confirmed == true && mounted) {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.logout();

      if (mounted) {
        AppToast.show(context, 'Logged out successfully');
        // Router will automatically redirect to /welcome
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop())
              context.pop();
            else
              context.go('/profile');
          },
        ),
      ),
      body: ListView(
        children: [
          // Account Settings
          _buildSectionHeader('Account Settings'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppToast.show(context, 'Change password coming soon!');
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email_outlined),
            title: const Text('Email Notifications'),
            value: _emailNotifications,
            onChanged: (value) {
              setState(() => _emailNotifications = value);
            },
            activeColor: AppColors.amberAccent,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Push Notifications'),
            value: _pushNotifications,
            onChanged: (value) {
              setState(() => _pushNotifications = value);
            },
            activeColor: AppColors.amberAccent,
          ),
          const Divider(),

          // Privacy Settings
          _buildSectionHeader('Privacy Settings'),
          SwitchListTile(
            secondary: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Anonymous Mode by Default'),
            subtitle: const Text('Hide your name when creating cassettes'),
            value: _anonymousModeDefault,
            onChanged: (value) {
              setState(() => _anonymousModeDefault = value);
            },
            activeColor: AppColors.amberAccent,
          ),
          const Divider(),

          // Support
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & FAQ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppToast.show(context, 'Help coming soon!');
            },
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Contact Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppToast.show(context, 'Contact support coming soon!');
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppToast.show(context, 'Privacy policy coming soon!');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppToast.show(context, 'Terms coming soon!');
            },
          ),
          const Divider(),

          // Danger Zone
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'Log Out',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: _handleLogout,
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              AppToast.show(context, 'Delete account coming soon!');
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // App Version
          Center(
            child: Text(
              'Digital Cassette v1.0.0',
              style: AppTypography.caption,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.lightBrown,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
