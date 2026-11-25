/// Domain entities for the Movie Details feature.

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final List<String> genres;
  final List<String> productionCountries;
  final String certification;
  final String director;
  final bool hasSubtitles;
  final String? authorizedDownloadUrl;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
    required this.productionCountries,
    this.certification = 'PG-13',
    this.director = '',
    this.hasSubtitles = true,
    this.authorizedDownloadUrl,
  });

  String get fullPosterUrl => _buildTmdbImageUrl(posterPath, 'w500');

  String get fullBackdropUrl => _buildTmdbImageUrl(backdropPath, 'w1280');

  String get releaseYear {
    if (releaseDate.length >= 4) return releaseDate.substring(0, 4);
    return '';
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get primaryCountry =>
      productionCountries.isNotEmpty ? productionCountries.first : 'United States';

  String get formattedRuntime {
    if (runtime <= 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }

  bool get hasDownloadableSource =>
      authorizedDownloadUrl != null &&
      authorizedDownloadUrl!.trim().isNotEmpty;

  MovieDetails copyWith({
    String? certification,
    String? director,
    String? authorizedDownloadUrl,
  }) {
    return MovieDetails(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
      runtime: runtime,
      genres: genres,
      productionCountries: productionCountries,
      certification: certification ?? this.certification,
      director: director ?? this.director,
      hasSubtitles: hasSubtitles,
      authorizedDownloadUrl:
          authorizedDownloadUrl ?? this.authorizedDownloadUrl,
    );
  }
}

class CastMember {
  final int id;
  final String name;
  final String role;
  final String profilePath;
  final bool isDirector;

  const CastMember({
    required this.id,
    required this.name,
    required this.role,
    required this.profilePath,
    this.isDirector = false,
  });

  String get fullProfileUrl => _buildTmdbImageUrl(profilePath, 'w185');
}

class MovieTrailer {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;
  final String? publishedAt;
  final String? durationLabel;
  final String? authorizedVideoUrl;
  final String? customThumbnailUrl;

  const MovieTrailer({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    this.official = false,
    this.publishedAt,
    this.durationLabel,
    this.authorizedVideoUrl,
    this.customThumbnailUrl,
  });

  String get watchUrl {
    if (authorizedVideoUrl != null && authorizedVideoUrl!.trim().isNotEmpty) {
      return authorizedVideoUrl!;
    }
    if (site.toLowerCase() == 'youtube' && key.isNotEmpty) {
      return 'https://www.youtube.com/watch?v=$key';
    }
    if (site.toLowerCase() == 'vimeo' && key.isNotEmpty) {
      return 'https://vimeo.com/$key';
    }
    return '';
  }

  String get thumbnailUrl {
    if (customThumbnailUrl != null && customThumbnailUrl!.trim().isNotEmpty) {
      return customThumbnailUrl!;
    }
    if (site.toLowerCase() == 'youtube' && key.isNotEmpty) {
      return 'https://img.youtube.com/vi/$key/hqdefault.jpg';
    }
    return '';
  }
}

class SimilarMovie {
  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final bool isTvMaze;

  const SimilarMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.isTvMaze = false,
  });

  String get fullPosterUrl => _buildTmdbImageUrl(posterPath, 'w500');

  String get formattedRating => voteAverage.toStringAsFixed(1);
}

class MovieReview {
  final String id;
  final String author;
  final String avatarPath;
  final String content;
  final double? rating;
  final DateTime? createdAt;

  const MovieReview({
    required this.id,
    required this.author,
    required this.avatarPath,
    required this.content,
    this.rating,
    this.createdAt,
  });

  String get fullAvatarUrl {
    if (avatarPath.trim().isEmpty) return '';
    if (avatarPath.startsWith('/https://') || avatarPath.startsWith('/http://')) {
      return avatarPath.substring(1);
    }
    return _buildTmdbImageUrl(avatarPath, 'w185');
  }
}

class MovieComment {
  final String id;
  final int movieId;
  final String userId;
  final String username;
  final String avatarUrl;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final bool isLikedByCurrentUser;
  final String? parentCommentId;
  final List<MovieComment> replies;

  const MovieComment({
    required this.id,
    required this.movieId,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.isLikedByCurrentUser = false,
    this.parentCommentId,
    this.replies = const [],
  });

  MovieComment copyWith({
    int? likesCount,
    bool? isLikedByCurrentUser,
    List<MovieComment>? replies,
  }) {
    return MovieComment(
      id: id,
      movieId: movieId,
      userId: userId,
      username: username,
      avatarUrl: avatarUrl,
      content: content,
      createdAt: createdAt,
      likesCount: likesCount ?? this.likesCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      parentCommentId: parentCommentId,
      replies: replies ?? this.replies,
    );
  }
}

String _buildTmdbImageUrl(String path, String size) {
  final trimmed = path.trim();
  if (trimmed.isEmpty) return '';
  if (trimmed.startsWith('http')) return trimmed;
  final normalized = trimmed.startsWith('/') ? trimmed : '/$trimmed';
  return 'https://image.tmdb.org/t/p/$size$normalized';
}

