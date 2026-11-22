import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';
import '../providers/explore_provider.dart';
import '../widgets/explore_filter_sheet.dart';
import '../widgets/explore_search_bar.dart';
import '../widgets/movie_grid.dart';
import '../widgets/top_searches_list.dart';

/// Main Movix Explore Screen matching the 7 Figma designs.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  static const _quickCategories = ['Movie', 'TV Shows', 'K-Drama', 'Anime'];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      ref.read(exploreProvider.notifier).setSearchFocused(_focusNode.hasFocus);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    final currentFilters = ref.read(exploreProvider).filters;
    ExploreFilterSheet.show(
      context,
      initialFilters: currentFilters,
      onApply: (newFilters) {
        ref.read(exploreProvider.notifier).applyFilters(newFilters);
      },
      onReset: () {
        ref.read(exploreProvider.notifier).resetFilters();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreProvider);
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: MovixBottomNavBar(
        currentIndex: 1, // Explore is active
        onTap: (index) {
          if (index == 0) {
            context.go(RoutePaths.home);
          } else if (index == 2) {
            context.go(RoutePaths.watchlist);
          } else if (index == 3) {
            context.go(RoutePaths.download);
          } else if (index == 4) {
            context.go(RoutePaths.profile);
          } else if (index != 1) {
            ref.read(exploreProvider.notifier).resetFilters();
          }
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Bar with Red Filter Button
            ExploreSearchBar(
              controller: _searchController,
              focusNode: _focusNode,
              hasActiveFilters: state.filters.hasActiveFilters,
              onChanged: (query) {
                ref.read(exploreProvider.notifier).onSearchQueryChanged(query);
              },
              onClear: () {
                ref.read(exploreProvider.notifier).clearSearch();
              },
              onFilterTap: _openFilterSheet,
            ),

            // 2. Horizontal Filter Pill Chips (Figma Screen 30 & 31)
            if (!state.showTopSearches) ...[
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Quick category pills
                    ..._quickCategories.map((cat) {
                      final isSelected = state.filters.category == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            final newCat = isSelected ? null : cat;
                            ref.read(exploreProvider.notifier).applyFilters(
                                  state.filters.copyWith(
                                    category: () => newCat,
                                  ),
                                );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryRed
                                  : (isDark
                                      ? const Color(0xFF1F222A)
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryRed
                                    : (isDark
                                        ? const Color(0xFF2E323E)
                                        : const Color(0xFFE50914)
                                            .withValues(alpha: 0.5)),
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white70
                                        : AppColors.primaryRed),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    // Active non-category filters (regions, genres, period)
                    ...state.filters.activeFilterChips
                        .where((c) => !_quickCategories.contains(c))
                        .map((chip) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(
                            chip,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: AppColors.primaryRed,
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                          onDeleted: () {
                            ref
                                .read(exploreProvider.notifier)
                                .removeFilterChip(chip);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 3. Dynamic Body State
            Expanded(
              child: state.isLoading
                  ? const Center(child: AppLoadingIndicator())
                  : state.showTopSearches
                      // Figma Screen 26: Top Searches
                      ? TopSearchesList(
                          topSearches: state.topSearches,
                          onSelect: (movie) {
                            _searchController.text = movie.title;
                            ref
                                .read(exploreProvider.notifier)
                                .onSearchQueryChanged(movie.title);
                            _focusNode.unfocus();
                          },
                        )
                      : state.showEmptyState
                          // Figma Screen 27: 404 Not Found State
                          ? _buildEmptyState(isDark)
                          // Figma Screen 25, 28, 30, 31: 2-Column Movie Grid
                          : MovieGrid(
                              movies: state.movies,
                              onMovieTap: (movie) {
                                final route = movie.isTvMaze
                                    ? RoutePaths.tvDetailsPath(movie.id)
                                    : RoutePaths.movieDetailsPath(movie.id);
                                context.push(route);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 404 Cute Illustration Text & Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '4',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1F222A),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryRed.withValues(alpha: 0.18)
                          : const Color(0xFFFFEBEE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.movie_filter_rounded,
                      color: AppColors.primaryRed,
                      size: 34,
                    ),
                  ),
                ),
                Text(
                  '4',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1F222A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Not Found Heading
            const Text(
              'Not Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              'Sorry, the keyword you entered could not be found. Try to check again or search with other keywords.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 24),

            // Clear Search Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                _searchController.clear();
                ref.read(exploreProvider.notifier).clearSearch();
                _focusNode.unfocus();
              },
              child: const Text(
                'Clear Search',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

