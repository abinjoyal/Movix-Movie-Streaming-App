import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/downloaded_movie.dart';
import 'download_progress.dart';

class DownloadMovieCard extends StatelessWidget {
  final DownloadedMovie movie;
  final VoidCallback? onPlay;
  final VoidCallback? onDelete;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  const DownloadMovieCard({
    super.key,
    required this.movie,
    this.onPlay,
    this.onDelete,
    this.onPause,
    this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final titleColor = isDark ? Colors.white : const Color(0xFF1F1F1F);
    final subtitleColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final badgeBgColor =
        isDark ? const Color(0xFF331418) : const Color(0xFFFEEAEB);
    final badgeTextColor =
        isDark ? const Color(0xFFFF5252) : AppColors.primaryRed;

    final isDownloadingOrPaused =
        movie.status == DownloadStatus.downloading ||
            movie.status == DownloadStatus.paused;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Movie Thumbnail with Play Button Overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 72,
                    child: AppCachedImage(
                      imageUrl: movie.fullBackdropUrl,
                      fit: BoxFit.cover,
                      errorIcon: Icons.movie_creation_outlined,
                      errorIconSize: 28,
                      memCacheWidth: 360,
                      memCacheHeight: 220,
                    ),
                  ),

                  // Translucent dark circle with Play Arrow
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // 2. Movie Info (Title, Duration, File Size Badge / Progress)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie.duration,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  if (isDownloadingOrPaused)
                    DownloadProgressWidget(
                      movie: movie,
                      onPause: onPause,
                      onResume: onResume,
                    )
                  else
                    // Pill Badge for file size
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        movie.fileSize,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 3. Red Delete Trash Icon
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.primaryRed,
                size: 22,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

