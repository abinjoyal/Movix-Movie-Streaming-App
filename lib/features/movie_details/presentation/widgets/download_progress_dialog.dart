import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../downloads/domain/entities/downloaded_movie.dart';
import '../../../downloads/presentation/providers/download_provider.dart';

/// Displays the centered Download progress modal matching Figma Screen 37.
Future<void> showDownloadProgressDialog(
  BuildContext context, {
  required String downloadId,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _DownloadProgressDialog(downloadId: downloadId),
  );
}

class _DownloadProgressDialog extends ConsumerWidget {
  final String downloadId;

  const _DownloadProgressDialog({required this.downloadId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;
    final trackColor =
        isDark ? AppColors.darkSurfaceElevated : const Color(0xFFE5E7EB);

    final downloads = ref.watch(downloadProvider).downloads;
    final movie = downloads
        .cast<DownloadedMovie?>()
        .firstWhere((d) => d?.id == downloadId, orElse: () => null);

    final progress = (movie?.progress ?? 0.0).clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final isPaused = movie?.status == DownloadStatus.paused;
    final isDone = movie?.status == DownloadStatus.downloaded;

    final totalMb = _parseEstimatedTotalMb(movie?.fileSize ?? '');
    final downloadedMb = (totalMb * progress).round();

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Download',
              style: TextStyle(
                color: AppColors.primaryRed,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isDone
                  ? 'Download complete!\nReady for offline viewing.'
                  : 'Movies still downloading...\nPlease wait or hide the process',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Divider(height: 1, color: dividerColor),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$downloadedMb / $totalMb MB',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: trackColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryRed,
                      ),
                    ),
                  ),
                ),
                if (movie != null && !isDone) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      final notifier = ref.read(downloadProvider.notifier);
                      if (isPaused) {
                        notifier.resume(movie.id);
                      } else {
                        notifier.pause(movie.id);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isPaused
                            ? Icons.play_circle_filled_rounded
                            : Icons.pause_circle_filled_rounded,
                        color: textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed.withValues(alpha: 0.12),
                  foregroundColor: AppColors.primaryRed,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Hide',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _parseEstimatedTotalMb(String fileSize) {
    final lower = fileSize.toLowerCase();
    final match = RegExp(r'([\d.]+)').firstMatch(lower);
    if (match == null) return 1400;
    final val = double.tryParse(match.group(1)!) ?? 1.4;
    if (lower.contains('gb')) return (val * 1024).round();
    return val.round().clamp(100, 10000);
  }
}

