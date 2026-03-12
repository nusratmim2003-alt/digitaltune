import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/cassette_widgets.dart';
import '../../../../core/widgets/state_widgets.dart';
import '../../../../data/services/mock_data_service.dart';
import '../../../../data/services/storage_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0: // Home
        // Already on home, do nothing
        break;
      case 1: // Library
        context.go('/library');
        break;
      case 2: // Create (center FAB-style)
        context.push('/create-cassette');
        break;
      case 3: // Notifications
        context.go('/notifications');
        break;
      case 4: // Profile
        context.go('/profile');
        break;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final mockService = ref.watch(mockDataServiceProvider);
    final sentCassettes = mockService.getMockSentCassettes().take(3).toList();
    final receivedCassettes =
        mockService.getMockReceivedCassettes().take(3).toList();
    final savedCassettes = mockService.getMockSavedCassettes().take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate refresh
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              AppToast.show(context, 'Refreshed!');
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: FutureBuilder<String?>(
                    future: ref.read(storageServiceProvider).getUserName(),
                    builder: (context, snapshot) {
                      final name = snapshot.data ?? 'there';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, $name',
                            style: AppTypography.h2,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'What memory will you create today?',
                            style: AppTypography.body.copyWith(
                              color: AppColors.lightBrown,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Primary CTA
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: PrimaryButton(
                    text: 'Create a Cassette',
                    icon: Icons.add_circle_outline,
                    onPressed: () => context.push('/create-cassette'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Sent section
                _buildSection(
                  context,
                  title: 'Sent',
                  cassettes: sentCassettes,
                  onViewAll: () => context.push('/library'),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Received section
                _buildSection(
                  context,
                  title: 'Inbox',
                  cassettes: receivedCassettes,
                  showNewBadge: true,
                  onViewAll: () => context.push('/library'),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Saved section
                _buildSection(
                  context,
                  title: 'Saved',
                  cassettes: savedCassettes,
                  onViewAll: () => context.push('/library'),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.amberAccent,
        unselectedItemColor: AppColors.lightBrown,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 32),
            activeIcon: Icon(Icons.add_circle, size: 32),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List cassettes,
    bool showNewBadge = false,
    VoidCallback? onViewAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.h3),
              if (cassettes.isNotEmpty)
                AppTextButton(text: 'View All', onPressed: onViewAll),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (cassettes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.album_outlined,
                    size: 48,
                    color: AppColors.lightBrown.withOpacity(0.5),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No ${title.toLowerCase()} cassettes yet',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.lightBrown,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              itemCount: cassettes.length,
              itemBuilder: (context, index) {
                final cassette = cassettes[index];
                return Container(
                  width: 280,
                  margin: EdgeInsets.only(
                    right: index < cassettes.length - 1 ? AppSpacing.md : 0,
                  ),
                  child: CassetteCard(
                    cassette: cassette,
                    showNewBadge: showNewBadge,
                    onTap: () => context.push('/memory/${cassette.id}'),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
