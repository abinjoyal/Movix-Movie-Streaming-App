import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/supabase/supabase_service.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../downloads/domain/entities/downloaded_movie.dart';
import '../../../downloads/presentation/providers/download_provider.dart';
import '../../../watchlist/domain/entities/watchlist_item.dart';
import '../../../watchlist/presentation/providers/watchlist_provider.dart';
import '../../domain/entities/movie_details.dart';
import '../providers/movie_details_provider.dart';
import '../widgets/cast_crew_section.dart';
import '../widgets/comments_section.dart';
import '../widgets/download_progress_dialog.dart';
import '../widgets/give_rating_sheet.dart';
import '../widgets/movie_action_buttons.dart';
import '../widgets/movie_backdrop.dart';
import '../widgets/movie_details_tabs.dart';
import '../widgets/movie_info_section.dart';
import '../widgets/movie_overview.dart';
import '../widgets/share_movie_sheet.dart';
import '../widgets/similar_movies_grid.dart';
import '../widgets/trailer_list.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  final int movieId;
  final bool isTvShow;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    this.isTvShow = false,
  });

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg =
        isDark ? AppColors.darkBackground : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final args = (id: widget.movieId, isTvShow: widget.isTvShow);
    final state = ref.watch(movieDetailsProvider(args));
    final notifier = ref.read(movieDetailsProvider(args).notifier);

    if (state.isLoading && state.details == null) {
      return Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(backgroundColor: scaffoldBg),
        body: const AppLoadingIndicator(),
      );
    }

    if (state.errorMessage != null && state.details == null) {
      return Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(backgroundColor: scaffoldBg),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.primaryRed,
                ),
                const SizedBox(height: 12),
                Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textPrimary, fontSize: 15),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: notifier.loadAll,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final movie = state.details!;
    final watchlistState = ref.watch(watchlistProvider);
    final existingWatchlist = watchlistState.items
        .cast<WatchlistItem?>()
        .firstWhere((item) => item?.tmdbId == movie.id, orElse: () => null);
    final isInWatchlist = existingWatchlist != null;

    final downloadState = ref.watch(downloadProvider);
    final existingDownload = downloadState.downloads
        .cast<DownloadedMovie?>()
        .firstWhere((item) => item?.tmdbId == movie.id, orElse: () => null);

    final currentUserId =
        ref.watch(supabaseClientProvider)?.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MovieBackdrop(
                  movie: movie,
                  isInWatchlist: isInWatchlist,
                  onBack: () => context.pop(),
                  onShare: () => showShareMovieSheet(
                    context,
                    movie,
                    isTvShow: widget.isTvShow,
                  ),
                  onToggleWatchlist: () => _toggleWatchlist(
                    movie: movie,
                    existing: existingWatchlist,
                    currentUserId: currentUserId,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MovieInfoSection(
                        movie: movie,
                        isInWatchlist: isInWatchlist,
                        onToggleWatchlist: () => _toggleWatchlist(
                          movie: movie,
                          existing: existingWatchlist,
                          currentUserId: currentUserId,
                        ),
                        onShare: () => showShareMovieSheet(
                          context,
                          movie,
                          isTvShow: widget.isTvShow,
                        ),
                        onRatingTap: () => showGiveRatingSheet(
                          context,
                          movie: movie,
                          initialRating: state.userRating,
                          onSubmitRating: (stars) {
                            notifier.submitUserRating(stars);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Submitted $stars/5 rating for "${movie.title}".',
                                ),
                              ),
                            );
                          },
                          onViewReviews: () => _showReviewsSheet(
                            context,
                            state.reviews,
                            textPrimary,
                            textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      MovieActionButtons(
                        downloadStatus: existingDownload?.status,
                        onPlay: () => _handlePlay(context, movie, state.trailers),
                        onDownload: () => _handleDownload(
                          context,
                          movie,
                          existingDownload,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MovieOverview(movie: movie, cast: state.cast),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CastCrewSection(
                    cast: state.cast,
                    onMemberTap: (member) {
                      context.push(
                        RoutePaths.castMoviesPath(
                          member.id,
                          name: member.name,
                          isTvMaze: widget.isTvShow,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: MovieDetailsTabsDelegate(tabController: _tabController),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            TrailerList(
              trailers: state.trailers,
              fallbackBackdropUrl: movie.fullBackdropUrl,
            ),
            SimilarMoviesGrid(
              movies: state.similarMovies,
              isLoadingMore: state.isLoadingMoreSimilar,
              hasMore: state.hasMoreSimilar,
              onLoadMore: notifier.loadMoreSimilarMovies,
            ),
            CommentsSection(
              comments: state.comments,
              totalCommentsCount: state.totalCommentsCount,
              showAllComments: state.showAllComments,
              isSubmitting: state.isSubmittingComment,
              currentUserId: currentUserId,
              replyingTo: state.replyingTo,
              onToggleSeeAll: notifier.toggleShowAllComments,
              onOpenFullComments: () {
                context.push(
                  RoutePaths.movieCommentsPath(
                    widget.movieId,
                    isTvShow: widget.isTvShow,
                  ),
                );
              },
              onSelectReply: notifier.setReplyingTo,
              onSubmitComment: notifier.addComment,
              onToggleLike: notifier.toggleLikeComment,
              onDeleteComment: notifier.deleteComment,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleWatchlist({
    required MovieDetails movie,
    required WatchlistItem? existing,
    required String? currentUserId,
  }) async {
    final notifier = ref.read(watchlistProvider.notifier);
    if (existing != null) {
      await notifier.removeItem(existing.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed "${movie.title}" from My List.')),
        );
      }
      return;
    }

    await notifier.addItem(
      WatchlistItem(
        id: 'tmdb_${movie.id}',
        userId: currentUserId ?? 'local',
        tmdbId: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        voteAverage: movie.voteAverage,
        contentType: 'Movie',
        createdAt: DateTime.now(),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added "${movie.title}" to My List.')),
      );
    }
  }

  void _handlePlay(
    BuildContext context,
    MovieDetails movie,
    List<MovieTrailer> trailers,
  ) {
    final playable = trailers
        .cast<MovieTrailer?>()
        .firstWhere(
          (t) => t != null && t.watchUrl.isNotEmpty,
          orElse: () => null,
        );
    if (playable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No authorized trailer stream is available yet.'),
        ),
      );
      return;
    }

    showTrailerPreviewSheet(
      context,
      playable,
      fallbackBackdropUrl: movie.fullBackdropUrl,
    );
  }

  Future<void> _handleDownload(
    BuildContext context,
    MovieDetails movie,
    DownloadedMovie? existingDownload,
  ) async {
    final downloadNotifier = ref.read(downloadProvider.notifier);

    if (existingDownload != null) {
      if (existingDownload.status == DownloadStatus.downloading ||
          existingDownload.status == DownloadStatus.paused) {
        await showDownloadProgressDialog(
          context,
          downloadId: existingDownload.id,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${movie.title}" is already in your Downloads.'),
          ),
        );
      }
      return;
    }

    if (!movie.hasDownloadableSource) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No authorized downloadable video source is available for this movie.',
          ),
        ),
      );
      return;
    }

    final downloadId = 'dl_${movie.id}';
    await downloadNotifier.addDownload(
      DownloadedMovie(
        id: downloadId,
        tmdbId: movie.id,
        title: movie.title,
        backdropPath: movie.backdropPath,
        posterPath: movie.posterPath,
        duration: movie.formattedRuntime.isNotEmpty
            ? movie.formattedRuntime
            : 'N/A',
        fileSize: 'Authorized Stream',
        status: DownloadStatus.downloading,
        progress: 0.0,
        downloadedAt: DateTime.now(),
      ),
    );
    if (mounted) {
      await showDownloadProgressDialog(context, downloadId: downloadId);
    }
  }

  Future<void> _showReviewsSheet(
    BuildContext context,
    List<MovieReview> reviews,
    Color textPrimary,
    Color textSecondary,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          builder: (_, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TMDB Reviews (${reviews.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.primaryRed,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: reviews.isEmpty
                      ? Center(
                          child: Text(
                            'No TMDB reviews found for this movie.',
                            style: TextStyle(color: textSecondary),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (_, index) {
                            final review = reviews[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: AppCachedImage(
                                        imageUrl: review.fullAvatarUrl,
                                        width: 34,
                                        height: 34,
                                        fit: BoxFit.cover,
                                        errorIcon: Icons.person_rounded,
                                        errorIconSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        review.author,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                    if (review.rating != null)
                                      Text(
                                        '★ ${review.rating!.toStringAsFixed(1)}',
                                        style: const TextStyle(
                                          color: AppColors.primaryRed,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.5,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  review.content,
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
