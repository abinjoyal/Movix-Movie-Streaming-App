import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/movie_details.dart';

class MovieBackdrop extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final bool isInWatchlist;
  final VoidCallback onToggleWatchlist;

  const MovieBackdrop({
    super.key,
    required this.movie,
    required this.onBack,
    required this.onShare,
    required this.isInWatchlist,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomFadeColor =
        isDark ? AppColors.darkBackground : AppColors.lightSurface;

    return SizedBox(
      height: 295,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppCachedImage(
            imageUrl: movie.fullBackdropUrl.isNotEmpty
                ? movie.fullBackdropUrl
                : movie.fullPosterUrl,
            width: double.infinity,
            height: 295,
            fit: BoxFit.cover,
            errorIcon: Icons.movie_creation_outlined,
            errorIconSize: 48,
            customErrorWidget: movie.fullBackdropUrl.isNotEmpty &&
                    movie.fullPosterUrl.isNotEmpty &&
                    movie.fullPosterUrl != movie.fullBackdropUrl
                ? AppCachedImage(
                    imageUrl: movie.fullPosterUrl,
                    width: double.infinity,
                    height: 295,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.25),
                    errorIcon: Icons.movie_creation_outlined,
                    errorIconSize: 48,
                  )
                : null,
          ),
          // Top and bottom gradient overlays for readability
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.transparent,
                  Colors.transparent,
                  bottomFadeColor.withValues(alpha: 0.25),
                ],
                stops: const [0.0, 0.28, 0.72, 1.0],
              ),
            ),
          ),
          // Top action bar
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackdropIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onPressed: onBack,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _BackdropIconButton(
                        icon: Icons.share_outlined,
                        tooltip: 'Share movie',
                        onPressed: onShare,
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        tooltip: 'More options',
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        onSelected: (value) {
                          if (value == 'watchlist') {
                            onToggleWatchlist();
                          } else if (value == 'share') {
                            onShare();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'watchlist',
                            child: Row(
                              children: [
                                Icon(
                                  isInWatchlist
                                      ? Icons.bookmark_remove_outlined
                                      : Icons.bookmark_add_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isInWatchlist
                                      ? 'Remove from My List'
                                      : 'Add to My List',
                                ),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share_outlined, size: 20),
                                SizedBox(width: 10),
                                Text('Share'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _BackdropIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.35),
        foregroundColor: Colors.white,
      ),
      icon: Icon(icon, size: 22),
    );
  }
}

