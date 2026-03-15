import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/cassette_widgets.dart';
import '../../../../data/models/cassette.dart';
import '../../domain/providers/library_provider.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String? _selectedEmotion;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch data for first tab
    Future.microtask(() {
      ref.read(libraryProvider.notifier).fetchSentCassettes();
    });

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  void _onTabChanged(int index) {
    final notifier = ref.read(libraryProvider.notifier);
    switch (index) {
      case 0:
        notifier.fetchSentCassettes();
        break;
      case 1:
        notifier.fetchInboxCassettes();
        break;
      case 2:
        notifier.fetchSavedCassettes();
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final libraryState = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.amberAccent,
          unselectedLabelColor: AppColors.lightBrown,
          indicatorColor: AppColors.amberAccent,
          tabs: const [
            Tab(text: 'Sent'),
            Tab(text: 'Inbox'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and filter bar
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: AppColors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search memories...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: AppColors.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMedium,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', null),
                      _buildFilterChip('Love', 'love'),
                      _buildFilterChip('Nostalgia', 'nostalgia'),
                      _buildFilterChip('Friendship', 'friendship'),
                      _buildFilterChip('Missing You', 'missingYou'),
                      _buildFilterChip('Apology', 'apology'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: libraryState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.amberAccent),
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCassetteGrid(libraryState.sentCassettes),
                      _buildCassetteGrid(libraryState.inboxCassettes),
                      _buildCassetteGrid(libraryState.savedCassettes),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedEmotion == value;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedEmotion = selected ? value : null);
        },
        selectedColor: AppColors.amberAccent,
        checkmarkColor: AppColors.white,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.white : AppColors.deepBrown,
        ),
      ),
    );
  }

  Widget _buildCassetteGrid(List<Cassette> cassettes) {
    if (cassettes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: AppColors.cassetteBrown,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 44,
                  color: AppColors.amberAccent,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('No cassettes yet'),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Your memories will appear here',
                style: TextStyle(color: AppColors.lightBrown),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: cassettes.length,
      itemBuilder: (context, index) {
        return CassetteCard(
          cassette: cassettes[index],
          onTap: () => context.push('/memory/${cassettes[index].id}'),
        );
      },
    );
  }
}
