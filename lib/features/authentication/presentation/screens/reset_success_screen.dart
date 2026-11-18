import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../widgets/primary_auth_button.dart';

/// Modal dialog screen showing successful password reset.
class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final dialogBg = isDark ? AppColors.darkSurface : Colors.white;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.75), // Dimmed dark overlay
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: dialogBg,
              borderRadius: BorderRadius.circular(28.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red Success Icon Badge
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Heading
                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  'Your account is ready to use. You will be redirected to the Home page in a few seconds..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 28),

                // Continue / Go to Home Button
                PrimaryAuthButton(
                  text: 'Go to Homepage',
                  onPressed: () {
                    context.go(RoutePaths.home);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

