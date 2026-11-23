import '../../domain/entities/movie.dart';

/// Data model representing TMDB Movie JSON response.
class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    super.posterPath,
    super.backdropPath,
    super.voteAverage,
    super.voteCount,
    super.releaseDate,
    super.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final genreIds = (json['genre_ids'] as List<dynamic>?)
            ?.map((e) => _mapGenreId(e as int))
            .where((g) => g.isNotEmpty)
            .toList() ??
        [];

    final rawVote = json['vote_average'];
    final double voteAverage = rawVote is num ? rawVote.toDouble() : 0.0;

    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: (json['title'] ?? json['name'] ?? 'Untitled') as String,
      overview: (json['overview'] ?? '') as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: voteAverage,
      voteCount: json['vote_count'] as int? ?? 0,
      releaseDate:
          (json['release_date'] ?? json['first_air_date']) as String?,
      genres: genreIds,
    );
  }

  static String _mapGenreId(int id) {
    switch (id) {
      case 28:
        return 'Action';
      case 12:
        return 'Adventure';
      case 16:
        return 'Animation';
      case 35:
        return 'Comedy';
      case 80:
        return 'Crime';
      case 99:
        return 'Documentary';
      case 18:
        return 'Drama';
      case 10751:
        return 'Family';
      case 14:
        return 'Fantasy';
      case 36:
        return 'History';
      case 27:
        return 'Horror';
      case 10402:
        return 'Music';
      case 9648:
        return 'Mystery';
      case 10749:
        return 'Romance';
      case 878:
        return 'Sci-Fi';
      case 10770:
        return 'TV Movie';
      case 53:
        return 'Thriller';
      case 10752:
        return 'War';
      case 37:
        return 'Western';
      default:
        return '';
    }
  }
}

