import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/api/tmdb_api_client.dart';
import '../../../../core/api/tmdb_config.dart';
import '../../../../core/api/tmdb_endpoints.dart';
import '../../../../core/api/tvmaze_api_client.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../../../core/supabase/supabase_service.dart';
import '../../domain/entities/movie_details.dart';
import '../models/cast_model.dart';
import '../models/movie_comment_model.dart';
import '../models/movie_details_model.dart';
import '../models/trailer_model.dart';
import 'local_movie_details_fallback.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieDetailsModel> getMovieDetails(
    int movieId, {
    bool isTvShow = false,
  });
  Future<List<CastModel>> getMovieCredits(int movieId, {bool isTvShow = false});
  Future<List<TrailerModel>> getMovieVideos(
    int movieId, {
    bool isTvShow = false,
  });
  Future<List<SimilarMovieModel>> getSimilarAndRecommendedMovies(
    int movieId, {
    int page = 1,
    bool isTvShow = false,
  });
  Future<List<MovieReviewModel>> getMovieReviews(int movieId, {int page = 1});
  Future<List<SimilarMovieModel>> getPersonMovies(
    int personId, {
    bool isTvMaze = false,
    String? personName,
  });

  Future<List<MovieComment>> getComments(int movieId);
  Future<MovieComment> addComment({
    required int movieId,
    required String content,
    String? parentCommentId,
    String? username,
    String? avatarUrl,
  });
  Future<void> toggleLikeComment({
    required String commentId,
    required bool currentlyLiked,
  });
  Future<void> deleteComment(String commentId);
}

class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  final TmdbApiClient _tmdbClient;
  final TvMazeApiClient _tvMazeClient;
  final SupabaseClient? _supabase;

  MovieDetailsRemoteDataSourceImpl(
    this._tmdbClient,
    this._tvMazeClient,
    this._supabase,
  );

  @override
  Future<MovieDetailsModel> getMovieDetails(
    int movieId, {
    bool isTvShow = false,
  }) async {
    if (isTvShow) {
      Map<String, dynamic>? data;
      try {
        final response = await _tvMazeClient.get<Map<String, dynamic>>(
          '/shows/$movieId',
          queryParameters: const {'embed': 'images'},
        );
        data = response.data;
      } catch (_) {
        final response = await _tvMazeClient.get<Map<String, dynamic>>(
          '/shows/$movieId',
        );
        data = response.data;
      }
      if (data == null) {
        throw StateError('Empty TV show details response from TVmaze.');
      }
      return MovieDetailsModel.fromTvMazeJson(data);
    }

    if (!TmdbConfig.isConfigured) {
      final fallback = LocalMovieDetailsFallback.findById(movieId);
      if (fallback != null) return fallback;
      throw StateError(
        'TMDB_API_KEY is not configured. Add your free key to `.env` and restart.',
      );
    }

    try {
      final detailsFuture = _tmdbClient.get<Map<String, dynamic>>(
        TmdbEndpoints.movieDetails(movieId),
      );
      final releaseDatesFuture = _fetchCertification(movieId);

      final detailsResponse = await detailsFuture;
      final certification = await releaseDatesFuture;

      final data = detailsResponse.data;
      if (data == null) {
        throw StateError('Empty movie details response from TMDB.');
      }

      return MovieDetailsModel.fromJson(data, certification: certification);
    } catch (_) {
      final fallback = LocalMovieDetailsFallback.findById(movieId);
      if (fallback != null) return fallback;
      rethrow;
    }
  }

  Future<String?> _fetchCertification(int movieId) async {
    try {
      final response = await _tmdbClient.get<Map<String, dynamic>>(
        TmdbEndpoints.movieReleaseDates(movieId),
      );
      final results = response.data?['results'] as List<dynamic>? ?? const [];

      String? extractCert(Map<String, dynamic> countryEntry) {
        final releaseDates =
            countryEntry['release_dates'] as List<dynamic>? ?? const [];
        for (final entry in releaseDates) {
          final cert =
              (entry as Map<String, dynamic>)['certification']
                  ?.toString()
                  .trim() ??
              '';
          if (cert.isNotEmpty) return cert;
        }
        return null;
      }

      for (final item in results) {
        final map = item as Map<String, dynamic>;
        if (map['iso_3166_1'] == 'US') {
          final cert = extractCert(map);
          if (cert != null) return cert;
        }
      }

      for (final item in results) {
        final cert = extractCert(item as Map<String, dynamic>);
        if (cert != null) return cert;
      }
    } catch (_) {
      // Certification lookup is supplementary; fall back gracefully.
    }
    return null;
  }

  @override
  Future<List<CastModel>> getMovieCredits(
    int movieId, {
    bool isTvShow = false,
  }) async {
    if (isTvShow) {
      final responses = await Future.wait([
        _tvMazeClient.get<List<dynamic>>('/shows/$movieId/crew'),
        _tvMazeClient.get<List<dynamic>>('/shows/$movieId/cast'),
      ]);
      final crew = (responses[0].data ?? const [])
          .whereType<Map<String, dynamic>>()
          .take(5)
          .map(CastModel.fromTvMazeCrewJson)
          .toList();
      final cast = (responses[1].data ?? const [])
          .whereType<Map<String, dynamic>>()
          .take(20)
          .map(CastModel.fromTvMazeCastJson)
          .toList();
      return [...crew, ...cast];
    }

    if (!TmdbConfig.isConfigured) {
      return _fallbackCastForMovie(movieId);
    }

    try {
      final response = await _tmdbClient.get<Map<String, dynamic>>(
        TmdbEndpoints.movieCredits(movieId),
      );
      final data = response.data ?? const {};
      final crewRaw = data['crew'] as List<dynamic>? ?? const [];
      final castRaw = data['cast'] as List<dynamic>? ?? const [];

      final directors = crewRaw
          .whereType<Map<String, dynamic>>()
          .where((c) => (c['job'] ?? '').toString().toLowerCase() == 'director')
          .map(CastModel.fromCrewJson)
          .toList();

      final castMembers = castRaw
          .whereType<Map<String, dynamic>>()
          .take(20)
          .map(CastModel.fromCastJson)
          .toList();

      return [...directors, ...castMembers];
    } catch (_) {
      return _fallbackCastForMovie(movieId);
    }
  }

  List<CastModel> _fallbackCastForMovie(int movieId) {
    final fallback = LocalMovieDetailsFallback.findById(movieId);
    if (fallback != null) {
      return LocalMovieDetailsFallback.castForMovie(fallback);
    }
    return const [];
  }

  @override
  Future<List<TrailerModel>> getMovieVideos(
    int movieId, {
    bool isTvShow = false,
  }) async {
    if (isTvShow) {
      final response = await _tvMazeClient.get<List<dynamic>>(
        '/shows/$movieId/episodes',
      );
      final episodes = response.data ?? const [];
      return episodes
          .whereType<Map<String, dynamic>>()
          .take(20)
          .map(TrailerModel.fromTvMazeEpisodeJson)
          .toList();
    }

    if (!TmdbConfig.isConfigured) {
      return const [];
    }

    final response = await _tmdbClient.get<Map<String, dynamic>>(
      TmdbEndpoints.movieVideos(movieId),
    );
    final results = response.data?['results'] as List<dynamic>? ?? const [];
    final trailers = results
        .whereType<Map<String, dynamic>>()
        .map(TrailerModel.fromJson)
        .where((video) => video.key.isNotEmpty)
        .toList();

    trailers.sort((a, b) {
      int rank(TrailerModel item) {
        if (item.type.toLowerCase() == 'trailer' && item.official) return 0;
        if (item.type.toLowerCase() == 'trailer') return 1;
        if (item.type.toLowerCase() == 'teaser') return 2;
        return 3;
      }

      return rank(a).compareTo(rank(b));
    });

    return trailers;
  }

  @override
  Future<List<SimilarMovieModel>> getSimilarAndRecommendedMovies(
    int movieId, {
    int page = 1,
    bool isTvShow = false,
  }) async {
    if (isTvShow) {
      if (page > 1) return const [];
      final response = await _tvMazeClient.get<List<dynamic>>('/shows?page=0');
      final shows = response.data ?? const [];
      return shows
          .whereType<Map<String, dynamic>>()
          .where((show) => show['image'] != null && show['id'] != movieId)
          .take(16)
          .map(SimilarMovieModel.fromTvMazeJson)
          .toList();
    }

    if (!TmdbConfig.isConfigured) {
      if (page > 1) return const [];
      return LocalMovieDetailsFallback.similarFor(movieId);
    }

    try {
      final responses = await Future.wait([
        _tmdbClient.get<Map<String, dynamic>>(
          TmdbEndpoints.movieRecommendations(movieId),
          queryParameters: {'page': page},
        ),
        _tmdbClient.get<Map<String, dynamic>>(
          TmdbEndpoints.movieSimilar(movieId),
          queryParameters: {'page': page},
        ),
      ]);

      final combined = <int, SimilarMovieModel>{};
      for (final response in responses) {
        final results = response.data?['results'] as List<dynamic>? ?? const [];
        for (final item in results.whereType<Map<String, dynamic>>()) {
          final movie = SimilarMovieModel.fromJson(item);
          if (movie.id > 0 && movie.id != movieId) {
            combined.putIfAbsent(movie.id, () => movie);
          }
        }
      }

      return combined.values.toList();
    } catch (_) {
      if (page > 1) return const [];
      return LocalMovieDetailsFallback.similarFor(movieId);
    }
  }

  @override
  Future<List<MovieReviewModel>> getMovieReviews(
    int movieId, {
    int page = 1,
  }) async {
    if (!TmdbConfig.isConfigured) {
      return const [];
    }

    final response = await _tmdbClient.get<Map<String, dynamic>>(
      TmdbEndpoints.movieReviews(movieId),
      queryParameters: {'page': page},
    );
    final results = response.data?['results'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(MovieReviewModel.fromJson)
        .toList();
  }

  @override
  Future<List<SimilarMovieModel>> getPersonMovies(
    int personId, {
    bool isTvMaze = false,
    String? personName,
  }) async {
    if (isTvMaze) {
      try {
        final response = await _tvMazeClient.get<List<dynamic>>(
          '/people/$personId/castcredits',
          queryParameters: const {'embed': 'show'},
        );
        final list = response.data ?? const [];
        final seen = <int>{};
        final shows = <SimilarMovieModel>[];
        for (final item in list.whereType<Map<String, dynamic>>()) {
          final embedded = item['_embedded'] as Map<String, dynamic>?;
          final showJson = embedded?['show'] as Map<String, dynamic>?;
          if (showJson == null) continue;
          final parsed = SimilarMovieModel.fromTvMazeJson(showJson);
          if (parsed.id > 0 && seen.add(parsed.id)) {
            shows.add(parsed);
          }
        }
        return shows;
      } catch (_) {
        return const [];
      }
    }

    if (!TmdbConfig.isConfigured) {
      return LocalMovieDetailsFallback.moviesForPerson(personName);
    }

    try {
      final response = await _tmdbClient.get<Map<String, dynamic>>(
        TmdbEndpoints.personMovieCredits(personId),
      );
      final data = response.data ?? const {};
      final rawList = [
        ...(data['cast'] as List<dynamic>? ?? const []),
        ...(data['crew'] as List<dynamic>? ?? const []),
      ];

      final combined = <int, SimilarMovieModel>{};
      for (final item in rawList.whereType<Map<String, dynamic>>()) {
        final movie = SimilarMovieModel.fromJson(item);
        if (movie.id > 0 && movie.posterPath.isNotEmpty) {
          combined.putIfAbsent(movie.id, () => movie);
        }
      }

      final movies = combined.values.toList()
        ..sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
      return movies;
    } catch (_) {
      return LocalMovieDetailsFallback.moviesForPerson(personName);
    }
  }

  SupabaseClient? get _activeClient {
    if (!SupabaseConfig.isConfigured || !SupabaseService.isInitialized) {
      return null;
    }
    return _supabase;
  }

  (SupabaseClient, User) _requireAuthenticatedClient(
    String unauthenticatedMessage,
  ) {
    final client = _activeClient;
    if (client == null) {
      throw StateError('Supabase is not configured for comments.');
    }
    final user = client.auth.currentUser;
    if (user == null) {
      throw StateError(unauthenticatedMessage);
    }
    return (client, user);
  }

  @override
  Future<List<MovieComment>> getComments(int movieId) async {
    final client = _activeClient;
    if (client == null) return const [];

    try {
      final rows = await client
          .from('movie_comments')
          .select()
          .eq('movie_id', movieId)
          .order('created_at', ascending: false);

      final commentList = List<Map<String, dynamic>>.from(rows);
      if (commentList.isEmpty) return const [];

      final commentIds = commentList
          .map((row) => row['id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      final likesByCommentId = <String, int>{};
      final likedCommentIds = <String>{};
      final currentUserId = client.auth.currentUser?.id;

      if (commentIds.isNotEmpty) {
        final likesRows = await client
            .from('movie_comment_likes')
            .select('comment_id, user_id')
            .inFilter('comment_id', commentIds);

        for (final like in List<Map<String, dynamic>>.from(likesRows)) {
          final cId = like['comment_id']?.toString() ?? '';
          final uId = like['user_id']?.toString() ?? '';
          if (cId.isEmpty) continue;
          likesByCommentId[cId] = (likesByCommentId[cId] ?? 0) + 1;
          if (currentUserId != null && uId == currentUserId) {
            likedCommentIds.add(cId);
          }
        }
      }

      final allParsed = commentList.map((row) {
        final id = (row['id'] ?? '').toString();
        final likesCount =
            likesByCommentId[id] ?? (row['likes_count'] as num?)?.toInt() ?? 0;
        return MovieCommentModel.fromJson({
          ...row,
          'likes_count': likesCount,
        }, isLikedByCurrentUser: likedCommentIds.contains(id));
      }).toList();

      final repliesByParent = <String, List<MovieComment>>{};
      final topLevel = <MovieComment>[];

      for (final comment in allParsed) {
        final parentId = comment.parentCommentId;
        if (parentId != null && parentId.isNotEmpty) {
          repliesByParent.putIfAbsent(parentId, () => []).add(comment);
        } else {
          topLevel.add(comment);
        }
      }

      return topLevel.map((comment) {
        final replies = (repliesByParent[comment.id] ?? const []).toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return comment.copyWith(replies: replies);
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<MovieComment> addComment({
    required int movieId,
    required String content,
    String? parentCommentId,
    String? username,
    String? avatarUrl,
  }) async {
    final (client, user) = _requireAuthenticatedClient(
      'Please sign in to post a comment.',
    );

    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Comment cannot be empty.');
    }

    final metadata = user.userMetadata ?? const {};
    final resolvedUsername = (username != null && username.trim().isNotEmpty)
        ? username.trim()
        : (metadata['full_name'] ??
                  metadata['name'] ??
                  user.email?.split('@').first ??
                  'Movix User')
              .toString();

    final resolvedAvatar = (avatarUrl != null && avatarUrl.trim().isNotEmpty)
        ? avatarUrl.trim()
        : (metadata['avatar_url'] ?? '').toString();

    final inserted = await client
        .from('movie_comments')
        .insert({
          'movie_id': movieId,
          'user_id': user.id,
          'username': resolvedUsername,
          'avatar_url': resolvedAvatar,
          'content': trimmed,
          if (parentCommentId != null && parentCommentId.isNotEmpty)
            'parent_comment_id': parentCommentId,
        })
        .select()
        .single();

    return MovieCommentModel.fromJson(inserted);
  }

  @override
  Future<void> toggleLikeComment({
    required String commentId,
    required bool currentlyLiked,
  }) async {
    final (client, user) = _requireAuthenticatedClient(
      'Please sign in to like comments.',
    );

    if (currentlyLiked) {
      await client
          .from('movie_comment_likes')
          .delete()
          .eq('comment_id', commentId)
          .eq('user_id', user.id);
    } else {
      await client.from('movie_comment_likes').upsert({
        'comment_id': commentId,
        'user_id': user.id,
      }, onConflict: 'comment_id,user_id');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    final (client, user) = _requireAuthenticatedClient(
      'Please sign in to delete your comment.',
    );

    await client
        .from('movie_comments')
        .delete()
        .eq('id', commentId)
        .eq('user_id', user.id);
  }
}
