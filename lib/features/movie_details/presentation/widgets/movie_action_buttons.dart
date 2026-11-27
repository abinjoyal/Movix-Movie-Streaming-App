import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../downloads/domain/entities/downloaded_movie.dart';

class MovieActionButtons extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onDownload;
  final DownloadStatus? downloadStatus;

  const MovieActionButtons({
    super.key,
    required this.onPlay,
    required this.onDownload,
    this.downloadStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryBg = isDark ? AppColors.darkSurface : Colors.white;

    final downloadLabel = switch (downloadStatus) {
      DownloadStatus.downloaded => 'Downloaded',
      DownloadStatus.downloading => 'Downloading...',
      DownloadStatus.paused => 'Paused',
      DownloadStatus.failed || null => 'Download',
    };

    final downloadIcon = switch (downloadStatus) {
      DownloadStatus.downloaded => Icons.download_done_rounded,
      DownloadStatus.downloading => Icons.downloading_rounded,
      _ => Icons.file_download_outlined,
    };

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onPlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              icon: const Icon(Icons.play_circle_filled_rounded, size: 20),
              label: const Text(
                'Play',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: onDownload,
              style: OutlinedButton.styleFrom(
                backgroundColor: secondaryBg,
                foregroundColor: AppColors.primaryRed,
                side: const BorderSide(color: AppColors.primaryRed, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              icon: Icon(downloadIcon, size: 20, color: AppColors.primaryRed),
              label: Text(
                downloadLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

