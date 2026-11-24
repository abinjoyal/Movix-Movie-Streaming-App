import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../domain/entities/movie.dart';
import '../providers/home_provider.dart';
import '../widgets/movie_poster_card.dart';

enum SeeAllType { top10, newReleases }

/// 2-Column Movie Grid screen matching Figma "Top 10 Movies This Week"
/// and "New Releases" See All designs.
class SeeAllMoviesScreen extends ConsumerWidget {
  final SeeAllType type;

  const SeeAllMoviesScreen({
    super.key,
    required this.type,
  });

  String get _title {
    switch (type) {
      case SeeAllType.top10:
        return 'Top 10 Movies This Week';
      case SeeAllType.newReleases:
        return 'New Releases';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F1F1F);

    final List<Movie> movies = switch (type) {
      SeeAllType.top10 => homeState.top10Movies,
      SeeAllType.newReleases => homeState.newReleases,
    };

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24,
            color: textColor,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
            color: textColor,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              size: 26,
              color: textColor,
            ),
            onPressed: () {
              context.push(RoutePaths.explore);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: homeState.isLoading
          ? const Center(child: AppLoadingIndicator())
          : movies.isEmpty
              ? Center(
                  child: Text(
                    'No movies found.',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF757575),
                      fontSize: 15,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MoviePosterCard(
                      movie: movie,
                      width: double.infinity,
                      height: double.infinity,
                      onTap: () {
                        context.push(RoutePaths.movieDetailsPath(movie.id));
                      },
                    );
                  },
                ),
    );
  }
}

