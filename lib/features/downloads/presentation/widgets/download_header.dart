import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Top header for Download screen matching Figma Screens 47 & 48.
class DownloadHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const DownloadHeader({
    super.key,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF1F1F1F);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Red "M" Logo & "Download" Title
          Row(
            children: [
              Image.asset(
                AppAssets.logo,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Text(
                'Download',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                  color: textColor,
                ),
              ),
            ],
          ),

          // 2. Search Icon
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              size: 26,
              color: textColor,
            ),
            onPressed: onSearchTap,
          ),
        ],
      ),
    );
  }
}

