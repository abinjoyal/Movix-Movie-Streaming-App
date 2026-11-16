import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../extensions/context_extensions.dart';

/// High-performance, disk & memory-cached image widget for Movix.
///
/// Features:
/// - Memory cache sizing to avoid UI stutter and memory pressure.
/// - Disk cache optimization for offline availability and zero reload latency.
/// - Fast fade-in transition (200ms).
/// - Elegant skeleton placeholder instead of heavy spinning indicators.
class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Alignment alignment;
  final IconData errorIcon;
  final double errorIconSize;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Widget? customPlaceholder;
  final Widget? customErrorWidget;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.errorIcon = Icons.movie_outlined,
    this.errorIconSize = 36,
    this.memCacheWidth,
    this.memCacheHeight,
    this.customPlaceholder,
    this.customErrorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final placeholderBg = isDark ? const Color(0xFF1E202B) : const Color(0xFFE5E5E5);
    final iconColor = isDark ? AppColors.darkTextMuted : const Color(0xFFB0B0B0);

    Widget placeholder() {
      if (customPlaceholder != null) return customPlaceholder!;
      return Container(
        width: width,
        height: height,
        color: placeholderBg,
        child: Center(
          child: Icon(
            errorIcon,
            size: errorIconSize,
            color: iconColor.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    Widget error() {
      if (customErrorWidget != null) return customErrorWidget!;
      return Container(
        width: width,
        height: height,
        color: placeholderBg,
        child: Center(
          child: Icon(
            errorIcon,
            size: errorIconSize,
            color: iconColor,
          ),
        ),
      );
    }

    Widget imageWidget;

    if (imageUrl.trim().isEmpty) {
      imageWidget = error();
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
        memCacheWidth: memCacheWidth ?? 500,
        memCacheHeight: memCacheHeight ?? 750,
        maxWidthDiskCache: 800,
        maxHeightDiskCache: 1200,
        placeholder: (context, url) => placeholder(),
        errorWidget: (context, url, err) => error(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

