import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/tmdb_api_client.dart';
import '../../../../core/api/tmdb_config.dart';
import '../../../../core/api/tvmaze_api_client.dart';
import '../../../../core/supabase/supabase_service.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/datasources/movie_details_remote_datasource.dart';
import '../../data/repositories/movie_details_repository_impl.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../../domain/usecases/get_movie_credits.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_movie_reviews.dart';
import '../../domain/usecases/get_movie_videos.dart';
import '../../domain/usecases/get_person_movies.dart';
import '../../domain/usecases/get_similar_movies.dart';
import '../../domain/usecases/movie_comments_usecases.dart';

typedef MovieDetailsArgs = ({int id, bool isTvShow});
typedef CastMoviesArgs = ({int personId, String personName, bool isTvMaze});

// --- Dependency Providers ---

final movieDetailsRemoteDataSourceProvider =
    Provider<MovieDetailsRemoteDataSource>((ref) {
  return MovieDetailsRemoteDataSourceImpl(
    ref.watch(tmdbApiClientProvider),
    ref.watch(tvmazeApiClientProvider),
    ref.watch(supabaseClientProvider),
  );
});

final movieDetailsRepositoryProvider = Provider<MovieDetailsRepository>((ref) {
  return MovieDetailsRepositoryImpl(
    ref.watch(movieDetailsRemoteDataSourceProvider),
  );
});

final getMovieDetailsUseCaseProvider = Provider<GetMovieDetailsUseCase>((ref) {
  return GetMovieDetailsUseCase(ref.watch(movieDetailsRepositoryProvider));
});

final getMovieCreditsUseCaseProvider = Provider<GetMovieCreditsUseCase>((ref) {
  return GetMovieCreditsUseCase(ref.watch(movieDetailsRepositoryProvider));
});

final getMovieVideosUseCaseProvider = Provider<GetMovieVideosUseCase>((ref) {
  return GetMovieVideosUseCase(ref.watch(movieDetailsRepositoryProvider));
});

final getSimilarMoviesUseCaseProvider = Provider<GetSimilarMoviesUseCase>((ref) {
  return GetSimilarMoviesUseCase(ref.watch(movieDetailsRepositoryProvider));
});

final getMovieReviewsUseCaseProvider = Provider<GetMovieReviewsUseCase>((ref) {
  return GetMovieReviewsUseCase(ref.watch(movieDetailsRepositoryProvider));
});

final getPersonMoviesUseCaseProvider = Provider<GetPersonMoviesUseCase>((ref) {
  return GetPersonMoviesUseCase(ref.watch(movieDetailsRepositoryProvider));
});

final movieCommentsUseCasesProvider = Provider<MovieCommentsUseCases>((ref) {
  return MovieCommentsUseCases(ref.watch(movieDetailsRepositoryProvider));
});

// --- State ---

class MovieDetailsState {
  final bool isLoading;
  final bool isSubmittingComment;
  final bool isLoadingMoreSimilar;
  final bool hasMoreSimilar;
  final int similarPage;
  final bool showAllComments;
  final MovieDetails? details;
  final List<CastMember> cast;
  final List<MovieTrailer> trailers;
  final List<SimilarMovie> similarMovies;
  final List<MovieReview> reviews;
  final List<MovieComment> comments;
  final MovieComment? replyingTo;
  final int? userRating;
  final String? errorMessage;

  const MovieDetailsState({
    this.isLoading = true,
    this.isSubmittingComment = false,
    this.isLoadingMoreSimilar = false,
    this.hasMoreSimilar = true,
    this.similarPage = 1,
    this.showAllComments = false,
    this.details,
    this.cast = const [],
    this.trailers = const [],
    this.similarMovies = const [],
    this.reviews = const [],
    this.comments = const [],
    this.replyingTo,
    this.userRating,
    this.errorMessage,
  });

  int get totalCommentsCount {
    var count = comments.length;
    for (final comment in comments) {
      count += comment.replies.length;
    }
    return count;
  }

  MovieDetailsState copyWith({
    bool? isLoading,
    bool? isSubmittingComment,
    bool? isLoadingMoreSimilar,
    bool? hasMoreSimilar,
    int? similarPage,
    bool? showAllComments,
    MovieDetails? details,
    List<CastMember>? cast,
    List<MovieTrailer>? trailers,
    List<SimilarMovie>? similarMovies,
    List<MovieReview>? reviews,
    List<MovieComment>? comments,
    MovieComment? replyingTo,
    bool clearReplyingTo = false,
    int? userRating,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MovieDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingComment: isSubmittingComment ?? this.isSubmittingComment,
      isLoadingMoreSimilar: isLoadingMoreSimilar ?? this.isLoadingMoreSimilar,
      hasMoreSimilar: hasMoreSimilar ?? this.hasMoreSimilar,
      similarPage: similarPage ?? this.similarPage,
      showAllComments: showAllComments ?? this.showAllComments,
      details: details ?? this.details,
      cast: cast ?? this.cast,
      trailers: trailers ?? this.trailers,
      similarMovies: similarMovies ?? this.similarMovies,
      reviews: reviews ?? this.reviews,
      comments: comments ?? this.comments,
      replyingTo: clearReplyingTo ? null : (replyingTo ?? this.replyingTo),
      userRating: userRating ?? this.userRating,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// --- Notifier ---

class MovieDetailsNotifier extends StateNotifier<MovieDetailsState> {
  final int _movieId;
  final bool _isTvShow;
  final Ref _ref;
  final GetMovieDetailsUseCase _getDetails;
  final GetMovieCreditsUseCase _getCredits;
  final GetMovieVideosUseCase _getVideos;
  final GetSimilarMoviesUseCase _getSimilarMovies;
  final GetMovieReviewsUseCase _getReviews;
  final MovieCommentsUseCases _commentsUseCases;

  MovieDetailsNotifier({
    required int movieId,
    bool isTvShow = false,
    required Ref ref,
    required GetMovieDetailsUseCase getDetails,
    required GetMovieCreditsUseCase getCredits,
    required GetMovieVideosUseCase getVideos,
    required GetSimilarMoviesUseCase getSimilarMovies,
    required GetMovieReviewsUseCase getReviews,
    required MovieCommentsUseCases commentsUseCases,
  })  : _movieId = movieId,
        _isTvShow = isTvShow,
        _ref = ref,
        _getDetails = getDetails,
        _getCredits = getCredits,
        _getVideos = getVideos,
        _getSimilarMovies = getSimilarMovies,
        _getReviews = getReviews,
        _commentsUseCases = commentsUseCases,
        super(const MovieDetailsState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final details = await _getDetails(_movieId, isTvShow: _isTvShow);

      final results = await Future.wait([
        _safeFetch(
          () => _getCredits(_movieId, isTvShow: _isTvShow),
          <CastMember>[],
        ),
        _safeFetch(
          () => _getVideos(_movieId, isTvShow: _isTvShow),
          <MovieTrailer>[],
        ),
        _safeFetch(
          () => _getSimilarMovies(_movieId, page: 1, isTvShow: _isTvShow),
          <SimilarMovie>[],
        ),
        _safeFetch(
          () => _isTvShow
              ? Future.value(<MovieReview>[])
              : _getReviews(_movieId, page: 1),
          <MovieReview>[],
        ),
        _safeFetch(() => _commentsUseCases.getComments(_movieId), <MovieComment>[]),
      ]);

      final cast = results[0] as List<CastMember>;
      final trailers = results[1] as List<MovieTrailer>;
      final similar = results[2] as List<SimilarMovie>;
      final reviews = results[3] as List<MovieReview>;
      final comments = results[4] as List<MovieComment>;

      final directorNames = cast
          .where((member) => member.isDirector)
          .map((member) => member.name)
          .where((name) => name.isNotEmpty)
          .join(', ');

      state = state.copyWith(
        isLoading: false,
        details: details.copyWith(director: directorNames),
        cast: cast,
        trailers: trailers,
        similarMovies: similar,
        hasMoreSimilar:
            !_isTvShow && TmdbConfig.isConfigured && similar.isNotEmpty,
        similarPage: 1,
        reviews: reviews,
        comments: comments,
      );
    } catch (e) {
      final msg = (!_isTvShow && !TmdbConfig.isConfigured)
          ? 'TMDB_API_KEY is missing. Add your free key to `.env` and restart the app.'
          : 'Unable to load details. Check your network connection.';
      state = state.copyWith(
        isLoading: false,
        errorMessage: msg,
      );
    }
  }

  Future<T> _safeFetch<T>(Future<T> Function() loader, T fallback) async {
    try {
      return await loader();
    } catch (_) {
      return fallback;
    }
  }

  Future<void> loadMoreSimilarMovies() async {
    if (state.isLoadingMoreSimilar || !state.hasMoreSimilar) return;

    state = state.copyWith(isLoadingMoreSimilar: true);
    final nextPage = state.similarPage + 1;

    try {
      final nextItems = await _getSimilarMovies(
        _movieId,
        page: nextPage,
        isTvShow: _isTvShow,
      );
      final existingIds = state.similarMovies.map((m) => m.id).toSet();
      final uniqueNew =
          nextItems.where((m) => !existingIds.contains(m.id)).toList();

      state = state.copyWith(
        isLoadingMoreSimilar: false,
        similarPage: nextPage,
        hasMoreSimilar: uniqueNew.isNotEmpty,
        similarMovies: [...state.similarMovies, ...uniqueNew],
      );
    } catch (_) {
      state = state.copyWith(isLoadingMoreSimilar: false);
    }
  }

  void setReplyingTo(MovieComment? comment) {
    if (comment == null) {
      state = state.copyWith(clearReplyingTo: true);
    } else {
      state = state.copyWith(replyingTo: comment);
    }
  }

  void toggleShowAllComments() {
    state = state.copyWith(showAllComments: !state.showAllComments);
  }

  void submitUserRating(int stars) {
    state = state.copyWith(userRating: stars.clamp(1, 5));
  }

  Future<String?> addComment(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return 'Please write a comment before sending.';

    state = state.copyWith(isSubmittingComment: true);
    try {
      final profile = _ref.read(profileProvider).profile;
      await _commentsUseCases.addComment(
        movieId: _movieId,
        content: trimmed,
        parentCommentId: state.replyingTo?.id,
        username: profile?.fullName,
        avatarUrl: profile?.avatarUrl,
      );

      final refreshed = await _commentsUseCases.getComments(_movieId);
      state = state.copyWith(
        isSubmittingComment: false,
        comments: refreshed,
        clearReplyingTo: true,
      );
      return null;
    } catch (e) {
      state = state.copyWith(isSubmittingComment: false);
      return _cleanErrorMessage(e);
    }
  }

  Future<String?> toggleLikeComment(MovieComment target) async {
    final currentlyLiked = target.isLikedByCurrentUser;

    try {
      await _commentsUseCases.toggleLike(
        commentId: target.id,
        currentlyLiked: currentlyLiked,
      );
      final updatedComments = state.comments.map((comment) {
        if (comment.id == target.id) {
          return _toggledComment(comment, currentlyLiked);
        }
        if (comment.replies.any((r) => r.id == target.id)) {
          final updatedReplies = comment.replies.map((reply) {
            if (reply.id == target.id) {
              return _toggledComment(reply, currentlyLiked);
            }
            return reply;
          }).toList();
          return comment.copyWith(replies: updatedReplies);
        }
        return comment;
      }).toList();

      state = state.copyWith(comments: updatedComments);
      return null;
    } catch (e) {
      return _cleanErrorMessage(e);
    }
  }

  MovieComment _toggledComment(MovieComment comment, bool wasLiked) {
    final nextCount =
        wasLiked ? (comment.likesCount - 1).clamp(0, 1 << 30) : comment.likesCount + 1;
    return comment.copyWith(
      isLikedByCurrentUser: !wasLiked,
      likesCount: nextCount,
    );
  }

  Future<String?> deleteComment(String commentId) async {
    try {
      await _commentsUseCases.deleteComment(commentId);
      final refreshed = await _commentsUseCases.getComments(_movieId);
      state = state.copyWith(comments: refreshed);
      return null;
    } catch (e) {
      return _cleanErrorMessage(e);
    }
  }

  String _cleanErrorMessage(Object error) {
    final text = error.toString();
    if (text.startsWith('Bad state: ')) {
      return text.substring('Bad state: '.length);
    }
    return 'Unable to complete action. Please make sure you are signed in.';
  }
}

final movieDetailsProvider = StateNotifierProvider.autoDispose
    .family<MovieDetailsNotifier, MovieDetailsState, MovieDetailsArgs>(
  (ref, args) {
    return MovieDetailsNotifier(
      movieId: args.id,
      isTvShow: args.isTvShow,
      ref: ref,
      getDetails: ref.watch(getMovieDetailsUseCaseProvider),
      getCredits: ref.watch(getMovieCreditsUseCaseProvider),
      getVideos: ref.watch(getMovieVideosUseCaseProvider),
      getSimilarMovies: ref.watch(getSimilarMoviesUseCaseProvider),
      getReviews: ref.watch(getMovieReviewsUseCaseProvider),
      commentsUseCases: ref.watch(movieCommentsUseCasesProvider),
    );
  },
);

final castMoviesProvider = FutureProvider.autoDispose
    .family<List<SimilarMovie>, CastMoviesArgs>((ref, args) {
  return ref.watch(getPersonMoviesUseCaseProvider)(
        args.personId,
        isTvMaze: args.isTvMaze,
        personName: args.personName,
      );
});

