import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/downloaded_movie.dart';

class DownloadProgressWidget extends StatelessWidget {
  final DownloadedMovie movie;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  const DownloadProgressWidget({
    super.key,
    required this.movie,
    this.onPause,
    this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isPaused = movie.status == DownloadStatus.paused;
    final percent = (movie.progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isPaused ? 'Paused ($percent%)' : 'Downloading ($percent%)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPaused
                    ? Colors.amber.shade700
                    : AppColors.primaryRed,
              ),
            ),
            GestureDetector(
              onTap: isPaused ? onResume : onPause,
              child: Icon(
                isPaused
                    ? Icons.play_circle_outline_rounded
                    : Icons.pause_circle_outline_rounded,
                size: 20,
                color: isPaused ? Colors.amber.shade700 : AppColors.primaryRed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: movie.progress,
            minHeight: 4,
            backgroundColor: isDark
                ? const Color(0xFF262A34)
                : const Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation<Color>(
              isPaused ? Colors.amber.shade700 : AppColors.primaryRed,
            ),
          ),
        ),
      ],
    );
  }
}

