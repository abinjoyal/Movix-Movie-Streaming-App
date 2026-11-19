import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';
import '../providers/download_provider.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/download_empty_state.dart';
import '../widgets/download_header.dart';
import '../widgets/download_movie_card.dart';

/// Movix Download Screen matching Figma Screens 47 & 48.
class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(downloadProvider);
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: MovixBottomNavBar(
        currentIndex: 3, // Download is active (index 3)
        onTap: (index) {
          if (index == 0) {
            context.go(RoutePaths.home);
          } else if (index == 1) {
            context.go(RoutePaths.explore);
          } else if (index == 2) {
            context.go(RoutePaths.watchlist);
          } else if (index == 4) {
            context.go(RoutePaths.profile);
          }
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Download Header with Movix Red "M" & Search icon
            DownloadHeader(
              onSearchTap: () {
                context.push(RoutePaths.explore);
              },
            ),
            const SizedBox(height: 4),

            // 2. Main Content (Loading, Empty State, or Movie List)
            Expanded(
              child: state.isLoading
                  ? const Center(child: AppLoadingIndicator())
                  : state.downloads.isEmpty
                      ? DownloadEmptyState(
                          onExplore: () {
                            context.go(RoutePaths.explore);
                          },
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: state.downloads.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            final movie = state.downloads[index];
                            return DownloadMovieCard(
                              movie: movie,
                              onPlay: () {
                                context.showSnackBar(
                                  'Playing ${movie.title} in offline mode...',
                                );
                              },
                              onDelete: () {
                                DeleteConfirmationDialog.show(
                                  context,
                                  movie: movie,
                                  onConfirmDelete: () {
                                    ref
                                        .read(downloadProvider.notifier)
                                        .delete(movie.id);
                                    context.showSnackBar(
                                      'Deleted ${movie.title} from downloads',
                                    );
                                  },
                                );
                              },
                              onPause: () {
                                ref
                                    .read(downloadProvider.notifier)
                                    .pause(movie.id);
                              },
                              onResume: () {
                                ref
                                    .read(downloadProvider.notifier)
                                    .resume(movie.id);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

