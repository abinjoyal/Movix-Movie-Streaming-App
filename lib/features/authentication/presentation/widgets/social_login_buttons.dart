import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';

/// "or continue with" divider and social login buttons (Facebook, Google, Apple).
class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final VoidCallback onFacebookPressed;

  const SocialLoginButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final dividerColor = isDark ? const Color(0xFF262A34) : const Color(0xFFE0E0E0);
    final textColor = isDark ? AppColors.darkTextSecondary : const Color(0xFF757575);

    return Column(
      children: [
        // "or continue with" divider
        Row(
          children: [
            Expanded(child: Divider(color: dividerColor, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: dividerColor, thickness: 1)),
          ],
        ),
        const SizedBox(height: 24),

        // Social Buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialImageButton(
              assetPath: AppAssets.icFacebook,
              fallbackIcon: Icons.facebook,
              fallbackColor: const Color(0xFF1877F2),
              onTap: onFacebookPressed,
            ),
            const SizedBox(width: 16),
            _SocialImageButton(
              assetPath: AppAssets.icGoogle,
              fallbackIconWidget: const Text(
                'G',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFFEA4335),
                ),
              ),
              onTap: onGooglePressed,
            ),
            const SizedBox(width: 16),
            _SocialImageButton(
              assetPath: AppAssets.icApple,
              isApple: true,
              fallbackIcon: Icons.apple,
              onTap: onApplePressed,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialImageButton extends StatelessWidget {
  final String assetPath;
  final IconData? fallbackIcon;
  final Color? fallbackColor;
  final Widget? fallbackIconWidget;
  final bool isApple;
  final VoidCallback onTap;

  const _SocialImageButton({
    required this.assetPath,
    this.fallbackIcon,
    this.fallbackColor,
    this.fallbackIconWidget,
    this.isApple = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final bgColor = isDark ? const Color(0xFF1F222A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262A34) : const Color(0xFFE8E8E8);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 82,
        height: 56,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          assetPath,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          // For Apple logo, ensure it renders white on dark backgrounds
          color: isApple && isDark ? Colors.white : null,
          errorBuilder: (context, error, stackTrace) {
            if (fallbackIconWidget != null) return fallbackIconWidget!;
            return Icon(
              fallbackIcon ?? Icons.account_circle,
              size: 28,
              color: fallbackColor ?? (isDark ? Colors.white : Colors.black),
            );
          },
        ),
      ),
    );
  }
}
