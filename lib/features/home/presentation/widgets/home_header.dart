import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Top bar displaying the Movix brand logo and quick action icons.
class HomeHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationsTap;

  const HomeHeader({super.key, this.onSearchTap, this.onNotificationsTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Movix Brand Logo
          Row(
            children: [
              Image.asset(
                AppAssets.logo,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                'MOVIX',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),

          // Search & Notification action buttons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search_rounded, size: 26),
                color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                onPressed: onSearchTap,
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 26),
                color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                onPressed: onNotificationsTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
