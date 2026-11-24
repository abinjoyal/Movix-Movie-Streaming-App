import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../watchlist/domain/entities/watchlist_item.dart';
import '../../../watchlist/presentation/providers/watchlist_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/featured_movie_banner.dart';
import '../widgets/movie_poster_card.dart';
import '../widgets/movie_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      bottomNavigationBar: MovixBottomNavBar(
        currentIndex: homeState.selectedNavIndex,
        onTap: (index) {
          if (index == 1) {
            context.go(RoutePaths.explore);
          } else if (index == 2) {
            context.go(RoutePaths.watchlist);
          } else if (index == 3) {
            context.go(RoutePaths.download);
          } else if (index == 4) {
            context.go(RoutePaths.profile);
          } else {
            ref.read(homeProvider.notifier).setNavIndex(index);
          }
        },
      ),
      body: homeState.isLoading
          ? const Center(child: AppLoadingIndicator())
          : RefreshIndicator(
              color: AppColors.primaryRed,
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              onRefresh: () => ref.read(homeProvider.notifier).loadHomeData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Full-Bleed Featured Movie Banner with Integrated Header
                    if (homeState.banners.isNotEmpty)
                      FeaturedMovieBanner(
                        movies: homeState.banners,
                        onPageChanged: (index) {
                          ref.read(homeProvider.notifier).setBannerIndex(index);
                        },
                        onPlay: (movie) {
                          context.push(RoutePaths.movieDetailsPath(movie.id));
                        },
                        onMyList: (movie) {
                          ref.read(watchlistProvider.notifier).addItem(
                                WatchlistItem(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  userId: 'default_user',
                                  tmdbId: movie.id,
                                  title: movie.title,
                                  posterPath: movie.posterPath ?? '',
                                  voteAverage: movie.voteAverage,
                                  contentType: 'Movie',
                                  createdAt: DateTime.now(),
                                ),
                              );
                          context.showSnackBar('Added ${movie.title} to My List');
                        },
                        onSearchTap: () {
                          context.go(RoutePaths.explore);
                        },
                        onNotificationsTap: () {
                          context.push(RoutePaths.notifications);
                        },
                      ),
                    const SizedBox(height: 16),

                    // 2. Top 10 Movies This Week Section (Matching Figma)
                    if (homeState.top10Movies.isNotEmpty) ...[
                      MovieSection(
                        title: 'Top 10 Movies This Week',
                        onSeeAll: () {
                          context.push(RoutePaths.top10Movies);
                        },
                        child: SizedBox(
                          height: 215,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: homeState.top10Movies.length,
                            itemBuilder: (context, index) {
                              final movie = homeState.top10Movies[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: MoviePosterCard(
                                  movie: movie,
                                  onTap: () {
                                    context.push(
                                      RoutePaths.movieDetailsPath(movie.id),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // 3. New Releases Section (Matching Figma)
                    if (homeState.newReleases.isNotEmpty) ...[
                      MovieSection(
                        title: 'New Releases',
                        onSeeAll: () {
                          context.push(RoutePaths.newReleases);
                        },
                        child: SizedBox(
                          height: 215,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: homeState.newReleases.length,
                            itemBuilder: (context, index) {
                              final movie = homeState.newReleases[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: MoviePosterCard(
                                  movie: movie,
                                  onTap: () {
                                    context.push(
                                      RoutePaths.movieDetailsPath(movie.id),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

