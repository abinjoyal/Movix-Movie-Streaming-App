import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/explore_movie.dart';

/// 2:3 Movie Poster Card matching Figma Explore grid with top-left red rating badge.
class ExploreMovieCard extends StatelessWidget {
  final ExploreMovie movie;
  final VoidCallback? onTap;

  const ExploreMovieCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? const Color(0xFF1F222A) : const Color(0xFFF0F0F0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Dynamic TMDB Network Poster Image with Caching
              AppCachedImage(
                imageUrl: movie.fullPosterUrl,
                fit: BoxFit.cover,
                errorIconSize: 38,
                memCacheWidth: 350,
                memCacheHeight: 520,
              ),

              // Figma Red Rating Badge on Top-Left
              if (movie.voteAverage > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      movie.formattedRating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

