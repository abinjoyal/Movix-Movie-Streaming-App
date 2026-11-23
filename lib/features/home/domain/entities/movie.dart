/// Domain entity representing a Movie in Movix.
class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final List<String> genres;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.releaseDate,
    this.genres = const [],
  });

  /// Full poster URL (w500)
  String get fullPosterUrl {
    if (posterPath == null || posterPath!.trim().isEmpty) return '';
    if (posterPath!.startsWith('http')) return posterPath!;
    final path = posterPath!.startsWith('/') ? posterPath! : '/$posterPath';
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  /// Full backdrop URL (w780 for fast loading & sharp display)
  String get fullBackdropUrl {
    if (backdropPath == null || backdropPath!.trim().isEmpty) return fullPosterUrl;
    if (backdropPath!.startsWith('http')) return backdropPath!;
    final path = backdropPath!.startsWith('/') ? backdropPath! : '/$backdropPath';
    return 'https://image.tmdb.org/t/p/w780$path';
  }

  /// Release year extracted from releaseDate
  String get releaseYear {
    if (releaseDate == null || releaseDate!.isEmpty) return 'N/A';
    final parts = releaseDate!.split('-');
    return parts.isNotEmpty ? parts[0] : 'N/A';
  }

  /// Formatted rating (e.g. 8.4)
  String get formattedRating => voteAverage.toStringAsFixed(1);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

