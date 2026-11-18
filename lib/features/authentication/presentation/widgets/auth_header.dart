import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Reusable authentication header displaying the Movix "M" logo and heading text.
class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showCard;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showCard)
          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              AppAssets.logo,
              fit: BoxFit.contain,
            ),
          )
        else
          Image.asset(
            AppAssets.logo,
            width: 84,
            height: 84,
            fit: BoxFit.contain,
          ),
        const SizedBox(height: 20),
        // Heading
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.isDarkMode ? Colors.white : const Color(0xFF1F1F1F),
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.isDarkMode
                  ? Colors.white70
                  : const Color(0xFF6B6B78),
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
