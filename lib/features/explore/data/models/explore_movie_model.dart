import '../../domain/entities/explore_movie.dart';

/// Data model for explore movies with JSON serialization.
class ExploreMovieModel extends ExploreMovie {
  const ExploreMovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    required super.releaseDate,
    required super.genres,
    super.category = 'Movie',
    super.region = 'English',
    super.isTvMaze = false,
  });

  factory ExploreMovieModel.fromTvMazeJson(
    Map<String, dynamic> json, {
    String category = 'TV Shows',
  }) {
    final image = json['image'] as Map<String, dynamic>? ?? const {};
    final medium = (image['medium'] ?? '').toString();
    final original = (image['original'] ?? medium).toString();
    final ratingMap = json['rating'] as Map<String, dynamic>? ?? const {};
    final network = json['network'] as Map<String, dynamic>? ??
        json['webChannel'] as Map<String, dynamic>? ??
        const {};
    final country = network['country'] as Map<String, dynamic>? ?? const {};
    final rawSummary = (json['summary'] ?? '').toString();
    final cleanOverview =
        rawSummary.replaceAll(RegExp(r'<[^>]*>'), '').trim();

    return ExploreMovieModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['name'] ?? 'Untitled').toString(),
      overview: cleanOverview,
      posterPath: medium.isNotEmpty ? medium : original,
      backdropPath: original.isNotEmpty ? original : medium,
      voteAverage: (ratingMap['average'] as num?)?.toDouble() ?? 7.5,
      voteCount: 0,
      releaseDate: (json['premiered'] ?? '').toString(),
      genres: (json['genres'] as List<dynamic>? ?? const [])
          .map((g) => g.toString())
          .where((g) => g.isNotEmpty)
          .toList(),
      category: category,
      region: (country['name'] ?? json['language'] ?? 'English').toString(),
      isTvMaze: true,
    );
  }

  factory ExploreMovieModel.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? json['name'] ?? 'Untitled') as String;
    final voteAvg = (json['vote_average'] as num?)?.toDouble() ?? 0.0;
    final voteCount = (json['vote_count'] as num?)?.toInt() ?? 0;
    final poster = (json['poster_path'] as String?) ?? '';
    final backdrop = (json['backdrop_path'] as String?) ?? '';
    final releaseDate =
        (json['release_date'] ?? json['first_air_date'] ?? '') as String;
    final overview = (json['overview'] as String?) ?? '';

    // Handle genres if provided as list of maps or ids
    List<String> parsedGenres = [];
    if (json['genres'] is List) {
      parsedGenres = (json['genres'] as List)
          .map((g) => (g is Map ? g['name']?.toString() : g.toString()) ?? '')
          .where((g) => g.isNotEmpty)
          .toList();
    } else if (json['genre_ids'] is List) {
      parsedGenres = _mapGenreIds((json['genre_ids'] as List).cast<int>());
    }

    return ExploreMovieModel(
      id: json['id'] as int? ?? 0,
      title: title,
      overview: overview,
      posterPath: poster,
      backdropPath: backdrop,
      voteAverage: voteAvg,
      voteCount: voteCount,
      releaseDate: releaseDate,
      genres: parsedGenres,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'genres': genres,
      'category': category,
      'region': region,
    };
  }

  static List<String> _mapGenreIds(List<int> ids) {
    const genreMap = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Sci-Fi',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };
    return ids.map((id) => genreMap[id] ?? 'General').toList();
  }
}

