import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/explore_movie.dart';

/// "Top Searches" suggestions list shown when search is focused and query is empty.
class TopSearchesList extends StatelessWidget {
  final List<ExploreMovie> topSearches;
  final void Function(ExploreMovie movie) onSelect;

  const TopSearchesList({
    super.key,
    required this.topSearches,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF1F1F1F);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Top Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...topSearches.map((movie) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: InkWell(
              onTap: () => onSelect(movie),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  // Poster Thumbnail with Play Circle Overlay
                  Container(
                    width: 110,
                    height: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDark ? const Color(0xFF1E202B) : const Color(0xFFE5E5E5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            movie.fullBackdropUrl.isNotEmpty
                                ? movie.fullBackdropUrl
                                : movie.fullPosterUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: isDark ? const Color(0xFF1E202B) : const Color(0xFFE5E5E5),
                              child: const Icon(Icons.movie_outlined, color: Colors.grey),
                            ),
                          ),
                          Container(
                            color: Colors.black.withValues(alpha: 0.25),
                            child: Center(
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 16,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & Genre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          movie.genres.isNotEmpty
                              ? movie.genres.join(' • ')
                              : movie.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Play / Select Icon
                  const Icon(
                    Icons.play_circle_outline_rounded,
                    color: AppColors.primaryRed,
                    size: 24,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

