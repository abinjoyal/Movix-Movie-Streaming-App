import '../../domain/entities/movie_details.dart';

class MovieDetailsModel extends MovieDetails {
  const MovieDetailsModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.runtime,
    required super.genres,
    required super.productionCountries,
    super.certification,
    super.director,
    super.hasSubtitles,
    super.authorizedDownloadUrl,
  });

  factory MovieDetailsModel.fromJson(
    Map<String, dynamic> json, {
    String? certification,
    String director = '',
  }) {
    final genresList = (json['genres'] as List<dynamic>? ?? const [])
        .map((e) => (e as Map<String, dynamic>)['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    final countriesList =
        (json['production_countries'] as List<dynamic>? ?? const [])
            .map((e) => (e as Map<String, dynamic>)['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();

    final isAdult = json['adult'] == true;
    final resolvedCert = (certification != null && certification.isNotEmpty)
        ? certification
        : (isAdult ? '18+' : '13+');

    final spokenLanguages =
        json['spoken_languages'] as List<dynamic>? ?? const [];

    return MovieDetailsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? json['original_title'] ?? '').toString(),
      overview: (json['overview'] ?? '').toString(),
      posterPath: (json['poster_path'] ?? '').toString(),
      backdropPath: (json['backdrop_path'] ?? '').toString(),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: (json['release_date'] ?? '').toString(),
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      genres: genresList,
      productionCountries: countriesList,
      certification: resolvedCert,
      director: director,
      hasSubtitles: spokenLanguages.isNotEmpty,
      authorizedDownloadUrl: json['authorized_download_url']?.toString(),
    );
  }

  factory MovieDetailsModel.fromTvMazeJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>? ?? const {};
    final medium = (image['medium'] ?? '').toString();
    final original = (image['original'] ?? medium).toString();
    final ratingMap = json['rating'] as Map<String, dynamic>? ?? const {};
    final network = json['network'] as Map<String, dynamic>? ??
        json['webChannel'] as Map<String, dynamic>? ??
        const {};
    final country = network['country'] as Map<String, dynamic>? ?? const {};
    final countryName = (country['name'] ?? '').toString();

    final embedded = json['_embedded'] as Map<String, dynamic>? ?? const {};
    final images = embedded['images'] as List<dynamic>? ?? const [];
    var backgroundUrl = original;
    for (final img in images.whereType<Map<String, dynamic>>()) {
      if (img['type'] == 'background') {
        final resolutions =
            img['resolutions'] as Map<String, dynamic>? ?? const {};
        final origRes =
            resolutions['original'] as Map<String, dynamic>? ?? const {};
        final url = (origRes['url'] ?? '').toString();
        if (url.isNotEmpty) {
          backgroundUrl = url;
          break;
        }
      }
    }

    final rawSummary = (json['summary'] ?? '').toString();
    final cleanOverview =
        rawSummary.replaceAll(RegExp(r'<[^>]*>'), '').trim();

    return MovieDetailsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['name'] ?? 'Untitled').toString(),
      overview: cleanOverview,
      posterPath: medium.isNotEmpty ? medium : original,
      backdropPath: backgroundUrl.isNotEmpty ? backgroundUrl : medium,
      voteAverage: (ratingMap['average'] as num?)?.toDouble() ?? 7.5,
      releaseDate: (json['premiered'] ?? '').toString(),
      runtime: (json['runtime'] as num?)?.toInt() ??
          (json['averageRuntime'] as num?)?.toInt() ??
          0,
      genres: (json['genres'] as List<dynamic>? ?? const [])
          .map((g) => g.toString())
          .where((g) => g.isNotEmpty)
          .toList(),
      productionCountries: countryName.isNotEmpty
          ? [countryName]
          : [(json['language'] ?? 'English').toString()],
      certification: 'TV-14',
      director: '',
      hasSubtitles: true,
    );
  }
}

class SimilarMovieModel extends SimilarMovie {
  const SimilarMovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    super.isTvMaze,
  });

  factory SimilarMovieModel.fromJson(Map<String, dynamic> json) {
    return SimilarMovieModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? json['name'] ?? '').toString(),
      posterPath: (json['poster_path'] ?? '').toString(),
      backdropPath: (json['backdrop_path'] ?? '').toString(),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: (json['release_date'] ?? '').toString(),
    );
  }

  factory SimilarMovieModel.fromTvMazeJson(Map<String, dynamic> json) {
    final image = json['image'] as Map<String, dynamic>? ?? const {};
    final medium = (image['medium'] ?? '').toString();
    final original = (image['original'] ?? medium).toString();
    final ratingMap = json['rating'] as Map<String, dynamic>? ?? const {};
    return SimilarMovieModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['name'] ?? '').toString(),
      posterPath: medium.isNotEmpty ? medium : original,
      backdropPath: original,
      voteAverage: (ratingMap['average'] as num?)?.toDouble() ?? 7.5,
      releaseDate: (json['premiered'] ?? '').toString(),
      isTvMaze: true,
    );
  }
}

class MovieReviewModel extends MovieReview {
  const MovieReviewModel({
    required super.id,
    required super.author,
    required super.avatarPath,
    required super.content,
    super.rating,
    super.createdAt,
  });

  factory MovieReviewModel.fromJson(Map<String, dynamic> json) {
    final authorDetails =
        json['author_details'] as Map<String, dynamic>? ?? const {};
    return MovieReviewModel(
      id: (json['id'] ?? '').toString(),
      author: (json['author'] ?? 'TMDB Reviewer').toString(),
      avatarPath: (authorDetails['avatar_path'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      rating: (authorDetails['rating'] as num?)?.toDouble(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()),
    );
  }
}

