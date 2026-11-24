import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/movie.dart';

/// Cinematic featured banner carousel matching the exact Figma reference
/// with integrated top header, left-aligned movie title, genres, and pill buttons.
class FeaturedMovieBanner extends StatefulWidget {
  final List<Movie> movies;
  final ValueChanged<int>? onPageChanged;
  final void Function(Movie)? onPlay;
  final void Function(Movie)? onMyList;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;

  const FeaturedMovieBanner({
    super.key,
    required this.movies,
    this.onPageChanged,
    this.onPlay,
    this.onMyList,
    this.onSearchTap,
    this.onNotificationsTap,
  });

  @override
  State<FeaturedMovieBanner> createState() => _FeaturedMovieBannerState();
}

class _FeaturedMovieBannerState extends State<FeaturedMovieBanner> {
  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    final screenHeight = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;

    return SizedBox(
      height: screenHeight * 0.48,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Swipeable Backdrop PageView
          PageView.builder(
            itemCount: widget.movies.length,
            onPageChanged: (index) {
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // High-Res TMDB Network Backdrop Image with disk & memory caching
                  AppCachedImage(
                    imageUrl: movie.fullBackdropUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorIconSize: 64,
                    memCacheWidth: 720,
                    memCacheHeight: 960,
                  ),

                  // Multi-stop Vignette & Gradient Overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.22, 0.60, 0.88, 1.0],
                          colors: [
                            Colors.black.withValues(alpha: 0.60),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.45),
                            bgColor.withValues(alpha: 0.88),
                            bgColor,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Left-aligned Movie Information & Action Buttons
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Movie Title
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.4,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Movie Genres / Subtitle
                        Text(
                          movie.genres.isNotEmpty
                              ? '${movie.genres.join(", ")}, ...'
                              : 'Action, Superhero, Science Fiction, ...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 8,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Pill Action Buttons: Play & + My List
                        Row(
                          children: [
                            // Play Button
                            InkWell(
                              onTap: () => widget.onPlay?.call(movie),
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryRed,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryRed.withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.play_circle_fill_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Play',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // + My List Button
                            InkWell(
                              onTap: () => widget.onMyList?.call(movie),
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'My List',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // 2. Overlaid Header on Top of Banner (Matching Figma)
          Positioned(
            top: statusBarHeight + 6,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Red "M" Brand Logo
                Image.asset(
                  AppAssets.logo,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),

                // Search & Notification icons
                Row(
                  children: [
                    _HeaderCircleButton(
                      icon: Icons.search_rounded,
                      onTap: widget.onSearchTap,
                    ),
                    const SizedBox(width: 12),
                    _HeaderCircleButton(
                      icon: Icons.notifications_none_rounded,
                      onTap: widget.onNotificationsTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _HeaderCircleButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.25),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}

