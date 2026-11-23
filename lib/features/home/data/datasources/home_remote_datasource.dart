import '../../../../core/api/tmdb_api_client.dart';
import '../../../../core/api/tmdb_config.dart';
import '../../../../core/api/tmdb_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../models/movie_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final TmdbApiClient _apiClient;

  HomeRemoteDataSourceImpl(this._apiClient);

  bool get _isKeyConfigured => TmdbConfig.isConfigured;

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    if (!_isKeyConfigured) {
      return _fallbackTrendingMovies;
    }

    try {
      final response = await _apiClient.get(TmdbEndpoints.trendingMoviesWeek);
      final results = response.data['results'] as List<dynamic>?;
      if (results == null) return _fallbackTrendingMovies;
      return results
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.w('Failed to fetch trending movies from TMDB: $e');
      return _fallbackTrendingMovies;
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    if (!_isKeyConfigured) {
      return _fallbackTopRatedMovies;
    }

    try {
      final response = await _apiClient.get(TmdbEndpoints.topRatedMovies);
      final results = response.data['results'] as List<dynamic>?;
      if (results == null) return _fallbackTopRatedMovies;
      return results
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.w('Failed to fetch top rated movies from TMDB: $e');
      return _fallbackTopRatedMovies;
    }
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    if (!_isKeyConfigured) {
      return _fallbackNowPlayingMovies;
    }

    try {
      final response = await _apiClient.get(TmdbEndpoints.nowPlayingMovies);
      final results = response.data['results'] as List<dynamic>?;
      if (results == null) return _fallbackNowPlayingMovies;
      return results
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.w('Failed to fetch now playing movies from TMDB: $e');
      return _fallbackNowPlayingMovies;
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    if (!_isKeyConfigured) {
      return _fallbackPopularMovies;
    }

    try {
      final response = await _apiClient.get(TmdbEndpoints.popularMovies);
      final results = response.data['results'] as List<dynamic>?;
      if (results == null) return _fallbackPopularMovies;
      return results
          .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.w('Failed to fetch popular movies from TMDB: $e');
      return _fallbackPopularMovies;
    }
  }

  // --- Real TMDB High-Resolution Fallback Data (Loaded via TMDB Image CDN) ---

  static const List<MovieModel> _fallbackPopularMovies = [
    MovieModel(
      id: 453395,
      title: 'Dr. Strange 2',
      overview:
          'Doctor Strange teams up with a mysterious teenage girl from his dreams who can travel across multiverses to battle multiple threats across the multiverse.',
      posterPath: '/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
      backdropPath: '/wcKFYIiVDvRURrzglV9kGu7fpfY.jpg',
      voteAverage: 9.2,
      voteCount: 7800,
      releaseDate: '2022-05-06',
      genres: ['Action', 'Superhero', 'Science Fiction'],
    ),
    MovieModel(
      id: 76600,
      title: 'Avatar 2',
      overview:
          'Set more than a decade after the events of the first film, learn the story of the Sully family, the trouble that follows them, and the lengths they go to keep each other safe.',
      posterPath: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      backdropPath: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg',
      voteAverage: 9.8,
      voteCount: 11000,
      releaseDate: '2022-12-16',
      genres: ['Sci-Fi', 'Adventure', 'Action'],
    ),
    MovieModel(
      id: 414906,
      title: 'The Batman',
      overview:
          'In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler.',
      posterPath: '/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      backdropPath: '/tRS6jvPM9qPrrnx2KRx3ew96Yot.jpg',
      voteAverage: 9.6,
      voteCount: 9200,
      releaseDate: '2022-03-04',
      genres: ['Action', 'Crime', 'Drama'],
    ),
  ];

  static const List<MovieModel> _fallbackTrendingMovies = [
    MovieModel(
      id: 76600,
      title: 'Avatar 2',
      overview:
          'Set more than a decade after the events of the first film, learn the story of the Sully family and the lengths they go to keep each other safe.',
      posterPath: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      backdropPath: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg',
      voteAverage: 9.8,
      voteCount: 11000,
      releaseDate: '2022-12-16',
      genres: ['Sci-Fi', 'Adventure'],
    ),
    MovieModel(
      id: 718789,
      title: 'Lightyear',
      overview:
          'Legendary Space Ranger Buzz Lightyear embarks on an intergalactic adventure alongside ambitious recruits and his robot companion Sox.',
      posterPath: '/vpILbP9eOQEtdQgl4vgjZUNY07r.jpg',
      backdropPath: '/2k9tBsv5NOtMzYVRbyeNTXpq7Al.jpg',
      voteAverage: 9.7,
      voteCount: 3200,
      releaseDate: '2022-06-17',
      genres: ['Animation', 'Adventure'],
    ),
    MovieModel(
      id: 414906,
      title: 'The Batman',
      overview:
          'Batman ventures into Gotham City\'s underworld when a sadistic killer leaves behind a trail of cryptic clues.',
      posterPath: '/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      backdropPath: '/tRS6jvPM9qPrrnx2KRx3ew96Yot.jpg',
      voteAverage: 9.6,
      voteCount: 9200,
      releaseDate: '2022-03-04',
      genres: ['Action', 'Crime'],
    ),
  ];

  static const List<MovieModel> _fallbackTopRatedMovies = [
    MovieModel(
      id: 76600,
      title: 'Avatar 2',
      overview:
          'Set more than a decade after the events of the first film, the story of the Sully family.',
      posterPath: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      backdropPath: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg',
      voteAverage: 9.8,
      voteCount: 11000,
      releaseDate: '2022-12-16',
      genres: ['Sci-Fi', 'Adventure'],
    ),
    MovieModel(
      id: 718789,
      title: 'Lightyear',
      overview:
          'Legendary Space Ranger Buzz Lightyear embarks on an intergalactic adventure.',
      posterPath: '/vpILbP9eOQEtdQgl4vgjZUNY07r.jpg',
      backdropPath: '/2k9tBsv5NOtMzYVRbyeNTXpq7Al.jpg',
      voteAverage: 9.7,
      voteCount: 3200,
      releaseDate: '2022-06-17',
      genres: ['Animation', 'Adventure'],
    ),
    MovieModel(
      id: 414906,
      title: 'The Batman',
      overview:
          'Batman ventures into Gotham City\'s underworld when a sadistic killer leaves behind a trail of cryptic clues.',
      posterPath: '/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      backdropPath: '/tRS6jvPM9qPrrnx2KRx3ew96Yot.jpg',
      voteAverage: 9.6,
      voteCount: 9200,
      releaseDate: '2022-03-04',
      genres: ['Action', 'Crime'],
    ),
    MovieModel(
      id: 507086,
      title: 'Jurassic World Dominion',
      overview:
          'Four years after the destruction of Isla Nublar, dinosaurs now live—and hunt—alongside humans all over the world.',
      posterPath: '/kAVRgw7GgK1CfYEJq8ME6EvRIgU.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.5,
      voteCount: 5800,
      releaseDate: '2022-06-10',
      genres: ['Adventure', 'Action', 'Sci-Fi'],
    ),
    MovieModel(
      id: 634649,
      title: 'Spider-Man: No Way Home',
      overview:
          'Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero.',
      posterPath: '/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
      backdropPath: '/4HodYYKEIsGOdinkGi2Ucz6X9i0.jpg',
      voteAverage: 9.4,
      voteCount: 18000,
      releaseDate: '2021-12-17',
      genres: ['Action', 'Adventure', 'Sci-Fi'],
    ),
    MovieModel(
      id: 675353,
      title: 'Sonic the Hedgehog 2',
      overview:
          'After settling in Green Hills, Sonic is eager to prove he has what it takes to be a true hero.',
      posterPath: '/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg',
      backdropPath: '/egoyMDLqCflOTx1qA43yK5b9oI5.jpg',
      voteAverage: 9.2,
      voteCount: 4600,
      releaseDate: '2022-04-08',
      genres: ['Animation', 'Action', 'Family'],
    ),
  ];

  static const List<MovieModel> _fallbackNowPlayingMovies = [
    MovieModel(
      id: 508947,
      title: 'Turning Red',
      overview:
          'Thirteen-year-old Mei poofs into a giant red panda whenever she gets too excited.',
      posterPath: '/qsdjk9oAKSQMWs0Vt5Pyfh6O4GZ.jpg',
      backdropPath: '/fOy2Jurz9k6RnJnMUMRDAgBwru2.jpg',
      voteAverage: 9.5,
      voteCount: 4700,
      releaseDate: '2022-03-10',
      genres: ['Animation', 'Comedy', 'Family'],
    ),
    MovieModel(
      id: 616037,
      title: 'Thor: Love and Thunder',
      overview:
          'Thor enlists the help of Valkyrie, Korg and ex-girlfriend Jane Foster to fight Gorr the God Butcher.',
      posterPath: '/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg',
      backdropPath: '/jsoz1HlxczSuTx0mDl2h0lxy36l.jpg',
      voteAverage: 9.7,
      voteCount: 6500,
      releaseDate: '2022-07-08',
      genres: ['Action', 'Adventure', 'Fantasy'],
    ),
    MovieModel(
      id: 436270,
      title: 'Black Adam',
      overview:
          'Nearly 5,000 years after he was bestowed with the almighty powers of the Egyptian gods, Black Adam is freed.',
      posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
      backdropPath: '/bQXAqRx2Fgc46uCVWgoPz5L5Dtr.jpg',
      voteAverage: 9.6,
      voteCount: 5400,
      releaseDate: '2022-10-21',
      genres: ['Action', 'Fantasy', 'Sci-Fi'],
    ),
    MovieModel(
      id: 505642,
      title: 'Black Panther: Wakanda Forever',
      overview:
          'Queen Ramonda, Shuri, M\'Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T\'Challa\'s death.',
      posterPath: '/sv1xJUazXeYqALzczSZ3O6nkH75.jpg',
      backdropPath: '/yYrvNvt2aqS13437gh5hkj14x2v.jpg',
      voteAverage: 9.5,
      voteCount: 6200,
      releaseDate: '2022-11-11',
      genres: ['Action', 'Adventure', 'Sci-Fi'],
    ),
    MovieModel(
      id: 526896,
      title: 'Morbius',
      overview:
          'Dangerously ill with a rare blood disorder, and determined to save others suffering his same fate, Dr. Morbius attempts a desperate gamble.',
      posterPath: '/6JjfSchsU6daXk2AKX8EEBjO3Fm.jpg',
      backdropPath: '/sp7MPK2Kudo4HbPWsbNXwtDCa0q.jpg',
      voteAverage: 9.4,
      voteCount: 4100,
      releaseDate: '2022-04-01',
      genres: ['Action', 'Sci-Fi', 'Fantasy'],
    ),
    // MovieModel(
    //   id: 406759,
    //   title: 'Moonfall',
    //   overview:
    //       'A mysterious force knocks the moon from its orbit around Earth and sends it hurtling on a collision course with life as we know it.',
    //   posterPath: '/odVv1sqVs0KxBXiA8bnIBlP6EET.jpg',
    //   backdropPath: '/wPUgVBOXCvZK7ICkKLsvL8pxfSf.jpg',
    //   voteAverage: 9.2,
    //   voteCount: 2900,
    //   releaseDate: '2022-02-04',
    //   genres: ['Sci-Fi', 'Adventure', 'Action'],
    // ),
  ];
}
