/// Domain entity representing a movie or show in the Explore screen.
class ExploreMovie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<String> genres;
  final String category; // 'Movie', 'TV Shows', 'K-Drama', 'Anime'
  final String region; // 'English', 'South Korean', 'Japanese', 'Chinese', 'Indian'
  final bool isTvMaze;

  const ExploreMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genres,
    this.category = 'Movie',
    this.region = 'English',
    this.isTvMaze = false,
  });

  String get fullPosterUrl {
    if (posterPath.trim().isEmpty) return '';
    if (posterPath.startsWith('http')) return posterPath;
    final path = posterPath.startsWith('/') ? posterPath : '/$posterPath';
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  String get fullBackdropUrl {
    if (backdropPath.trim().isEmpty) return '';
    if (backdropPath.startsWith('http')) return backdropPath;
    final path = backdropPath.startsWith('/') ? backdropPath : '/$backdropPath';
    return 'https://image.tmdb.org/t/p/w780$path';
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get releaseYear {
    if (releaseDate.length >= 4) {
      return releaseDate.substring(0, 4);
    }
    return '';
  }
}

