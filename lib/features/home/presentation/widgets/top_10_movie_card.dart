import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/movie.dart';

/// Top 10 Ranked Movie Card featuring a bold ranking number (1-10).
class Top10MovieCard extends StatelessWidget {
  final int rank;
  final Movie movie;
  final VoidCallback? onTap;

  const Top10MovieCard({
    super.key,
    required this.rank,
    required this.movie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Poster Card
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF0F0F0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.fullPosterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark ? AppColors.darkSurface : const Color(0xFFE5E5E5),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDark ? AppColors.darkSurface : const Color(0xFFE5E5E5),
                          child: const Icon(
                            Icons.broken_image_rounded,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ),

                      // Rating badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.ratingYellow,
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                movie.formattedRating,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Overlapping Stylized Rank Number (1-10)
            Positioned(
              left: 4,
              bottom: -8,
              child: Stack(
                children: [
                  // Text stroke / outline
                  Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = isDark ? Colors.black : Colors.white,
                    ),
                  ),
                  // Solid fill
                  Text(
                    '$rank',
                    style: const TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

