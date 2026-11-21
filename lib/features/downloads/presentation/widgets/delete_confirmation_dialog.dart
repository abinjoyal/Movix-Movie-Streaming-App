import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/downloaded_movie.dart';

/// Bottom sheet dialog for confirming movie deletion matching Figma Screen 48.
class DeleteConfirmationDialog extends StatelessWidget {
  final DownloadedMovie movie;
  final VoidCallback onConfirmDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.movie,
    required this.onConfirmDelete,
  });

  static Future<bool?> show(
    BuildContext context, {
    required DownloadedMovie movie,
    required VoidCallback onConfirmDelete,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeleteConfirmationDialog(
        movie: movie,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final bgColor = isDark ? const Color(0xFF1B1B22) : Colors.white;
    final cardBgColor =
        isDark ? const Color(0xFF262630) : const Color(0xFFF9F9FB);
    final titleColor = isDark ? Colors.white : const Color(0xFF1F1F1F);
    final subtitleColor =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final badgeBgColor =
        isDark ? const Color(0xFF331418) : const Color(0xFFFEEAEB);
    final badgeTextColor =
        isDark ? const Color(0xFFFF5252) : AppColors.primaryRed;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),

            // 1. Heading "Delete" in Movix Red
            const Text(
              'Delete',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            Divider(
              color: isDark ? const Color(0xFF2C2C38) : const Color(0xFFEEEEEE),
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // 2. Question Text
            Text(
              'Are you sure you want to delete this\nmovie download?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: titleColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // 3. Movie Summary Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF333342)
                      : const Color(0xFFEBEBEB),
                ),
              ),
              child: Row(
                children: [
                  // Thumbnail with play button
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 60,
                          child: Image.network(
                            movie.fullBackdropUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey.shade800,
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          movie.duration,
                          style: TextStyle(
                            fontSize: 12,
                            color: subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            movie.fileSize,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Action Buttons (Cancel / Yes, Delete)
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF331418)
                            : const Color(0xFFFEEAEB),
                        foregroundColor: isDark
                            ? const Color(0xFFFF5252)
                            : AppColors.primaryRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Yes, Delete Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirmDelete();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: AppColors.primaryRed.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Yes, Delete',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

