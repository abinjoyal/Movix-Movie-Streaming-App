import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';

class DownloadEmptyState extends StatelessWidget {
  final VoidCallback onExplore;

  const DownloadEmptyState({
    super.key,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final titleColor = isDark ? Colors.white : const Color(0xFF1F1F1F);
    final subtitleColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Download Tray Illustration
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF20202A) : const Color(0xFFFEEAEB),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.file_download_outlined,
                  size: 64,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Heading
            Text(
              'No Downloads Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              'Movies and episodes you download will appear here for offline viewing.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // Action Button
            ElevatedButton(
              onPressed: onExplore,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 14.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Explore Movies',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

