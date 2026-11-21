import '../../../../core/api/tmdb_api_client.dart';
import '../../../../core/api/tmdb_config.dart';
import '../../../../core/api/tvmaze_api_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/explore_movie_model.dart';

abstract class ExploreRemoteDataSource {
  Future<List<ExploreMovieModel>> searchMovies(String query);
  Future<List<ExploreMovieModel>> filterMovies({
    String? category,
    List<String>? regions,
    List<String>? genres,
    String? period,
    String? sortBy,
  });
  Future<List<ExploreMovieModel>> getTopSearches();
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  final TmdbApiClient _apiClient;
  final TvMazeApiClient? _tvMazeClient;

  ExploreRemoteDataSourceImpl(this._apiClient, [this._tvMazeClient]);

  bool get _isKeyConfigured => TmdbConfig.isConfigured;

  @override
  Future<List<ExploreMovieModel>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    if (!_isKeyConfigured) {
      final tvResults = await _searchTvMaze(query);
      if (tvResults.isNotEmpty) return tvResults;

      final q = query.toLowerCase();
      return _allSampleExploreMovies.where((m) {
        return m.title.toLowerCase().contains(q) ||
            m.genres.any((g) => g.toLowerCase().contains(q));
      }).toList();
    }

    try {
      final response = await _apiClient.get(
        '/search/multi',
        queryParameters: {'query': query, 'include_adult': false},
      );
      final results = response.data['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) {
        final q = query.toLowerCase();
        return _allSampleExploreMovies
            .where((m) => m.title.toLowerCase().contains(q))
            .toList();
      }
      return results
          .where((json) => json['poster_path'] != null)
          .map((json) => ExploreMovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.w('Search movies TMDB call failed: $e');
      final q = query.toLowerCase();
      return _allSampleExploreMovies
          .where((m) => m.title.toLowerCase().contains(q))
          .toList();
    }
  }

  @override
  Future<List<ExploreMovieModel>> filterMovies({
    String? category,
    List<String>? regions,
    List<String>? genres,
    String? period,
    String? sortBy,
  }) async {
    final isTv = category == 'TV Shows' ||
        category == 'K-Drama' ||
        category == 'Anime';

    if (!_isKeyConfigured) {
      if (isTv) {
        final tvShows = await _fetchTvMazeShows(
          category: category,
          genres: genres,
          period: period,
          sortBy: sortBy,
        );
        if (tvShows.isNotEmpty) return tvShows;
      }
      return _filterLocal(category, regions, genres, period, sortBy);
    }

    try {
      final endpoint = isTv ? '/discover/tv' : '/discover/movie';

      final Map<String, dynamic> params = {'include_adult': false};

      // Region/Language mapping
      if (regions != null && regions.isNotEmpty && !regions.contains('All Regions')) {
        if (regions.contains('South Korean')) params['with_original_language'] = 'ko';
        if (regions.contains('Japanese')) params['with_original_language'] = 'ja';
        if (regions.contains('Chinese')) params['with_original_language'] = 'zh';
        if (regions.contains('Indian')) params['with_original_language'] = 'hi';
        if (regions.contains('English')) params['with_original_language'] = 'en';
      }

      // Period / Year
      if (period != null && period != 'All Periods' && period.isNotEmpty) {
        if (isTv) {
          params['first_air_date_year'] = period;
        } else {
          params['primary_release_year'] = period;
        }
      }

      // Sort
      if (sortBy != null) {
        switch (sortBy) {
          case 'Latest Release':
            params['sort_by'] = isTv ? 'first_air_date.desc' : 'primary_release_date.desc';
            break;
          case 'Top Rated':
            params['sort_by'] = 'vote_average.desc';
            break;
          case 'Popularity':
          default:
            params['sort_by'] = 'popularity.desc';
            break;
        }
      }

      final response = await _apiClient.get(endpoint, queryParameters: params);
      final results = response.data['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) {
        return _filterLocal(category, regions, genres, period, sortBy);
      }
      return results
          .where((json) => json['poster_path'] != null)
          .map((json) => ExploreMovieModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.w('Filter movies TMDB call failed: $e');
      return _filterLocal(category, regions, genres, period, sortBy);
    }
  }

  @override
  Future<List<ExploreMovieModel>> getTopSearches() async {
    return _topSearches;
  }

  Future<List<ExploreMovieModel>> _searchTvMaze(String query) async {
    final client = _tvMazeClient;
    if (client == null) return const [];

    try {
      final response = await client.get<List<dynamic>>(
        '/search/shows',
        queryParameters: {'q': query},
      );
      final raw = response.data ?? const [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((item) => item['show'])
          .whereType<Map<String, dynamic>>()
          .where((show) => show['image'] != null)
          .map((show) => ExploreMovieModel.fromTvMazeJson(show))
          .toList();
    } catch (e) {
      AppLogger.w('TVmaze search failed: $e');
      return const [];
    }
  }

  Future<List<ExploreMovieModel>> _fetchTvMazeShows({
    String? category,
    List<String>? genres,
    String? period,
    String? sortBy,
  }) async {
    final client = _tvMazeClient;
    if (client == null) return const [];

    try {
      final response = await client.get<List<dynamic>>('/shows?page=0');
      final raw = response.data ?? const [];
      var shows = raw
          .whereType<Map<String, dynamic>>()
          .where((show) => show['image'] != null)
          .map(
            (show) => ExploreMovieModel.fromTvMazeJson(
              show,
              category: category ?? 'TV Shows',
            ),
          )
          .toList();

      if (category == 'Anime') {
        final animeOnly = shows
            .where((s) => s.genres.any((g) => g.toLowerCase() == 'anime'))
            .toList();
        if (animeOnly.isNotEmpty) shows = animeOnly;
      }

      if (genres != null && genres.isNotEmpty) {
        final filtered = shows
            .where((s) => s.genres.any((g) => genres.contains(g)))
            .toList();
        if (filtered.isNotEmpty) shows = filtered;
      }

      if (period != null && period.isNotEmpty && period != 'All Periods') {
        final byYear = shows
            .where((s) => s.releaseDate.startsWith(period))
            .toList();
        if (byYear.isNotEmpty) shows = byYear;
      }

      if (sortBy == 'Top Rated') {
        shows.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
      } else if (sortBy == 'Latest Release') {
        shows.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
      }

      return shows.take(30).toList();
    } catch (e) {
      AppLogger.w('TVmaze shows fetch failed: $e');
      return const [];
    }
  }

  List<ExploreMovieModel> _filterLocal(
    String? category,
    List<String>? regions,
    List<String>? genres,
    String? period,
    String? sortBy,
  ) {
    var list = List<ExploreMovieModel>.from(_allSampleExploreMovies);

    if (category != null && category.isNotEmpty) {
      list = list.where((m) => m.category == category).toList();
    }

    if (regions != null && regions.isNotEmpty && !regions.contains('All Regions')) {
      list = list.where((m) => regions.contains(m.region)).toList();
    }

    if (genres != null && genres.isNotEmpty) {
      list = list.where((m) => m.genres.any((g) => genres.contains(g))).toList();
    }

    if (period != null && period.isNotEmpty && period != 'All Periods') {
      list = list.where((m) => m.releaseDate.startsWith(period)).toList();
    }

    if (sortBy == 'Top Rated') {
      list.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    } else if (sortBy == 'Latest Release') {
      list.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    }

    // If filtered list is empty, return a reasonable subset
    return list.isNotEmpty ? list : _allSampleExploreMovies.take(6).toList();
  }

  // --- Real TMDB High-Resolution Data Matching Figma Screenshots ---

  static const List<ExploreMovieModel> _topSearches = [
    ExploreMovieModel(
      id: 66732,
      title: 'Stranger Things',
      overview: 'When a young boy vanishes, a small town uncovers a mystery.',
      posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.6,
      voteCount: 16000,
      releaseDate: '2022-05-27',
      genres: ['Sci-Fi', 'Drama', 'Mystery'],
      category: 'TV Shows',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 864116,
      title: 'Clean',
      overview: 'Tormented by a past life, garbage man Clean attempts a quiet life.',
      posterPath: '/ynu0fCQydIcXLFLwzZWLUHKSkrZ.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.6,
      voteCount: 3400,
      releaseDate: '2022-01-28',
      genres: ['Action', 'Thriller', 'Crime'],
      category: 'Movie',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 71446,
      title: 'Money Heist',
      overview: 'To carry out the biggest heist in history, a mysterious man recruits eight thieves.',
      posterPath: '/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg',
      backdropPath: '/gFZriCkpJYsApPZEF3jhxL4yLzG.jpg',
      voteAverage: 9.4,
      voteCount: 17800,
      releaseDate: '2021-12-03',
      genres: ['Crime', 'Action', 'Drama'],
      category: 'TV Shows',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 93405,
      title: 'Squid Game',
      overview: 'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games.',
      posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
      backdropPath: '/oaGvjB0DvdhX9ar97a6Cc9Qph2W.jpg',
      voteAverage: 9.3,
      voteCount: 13200,
      releaseDate: '2021-09-17',
      genres: ['Action', 'Mystery', 'Drama'],
      category: 'K-Drama',
      region: 'South Korean',
    ),
  ];

  static const List<ExploreMovieModel> _allSampleExploreMovies = [
    // --- Movies Category ---
    ExploreMovieModel(
      id: 872585,
      title: 'Oppenheimer',
      overview: 'The story of J. Robert Oppenheimer\'s role in the development of the atomic bomb.',
      posterPath: '/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
      backdropPath: '/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg',
      voteAverage: 9.7,
      voteCount: 12850,
      releaseDate: '2023-07-19',
      genres: ['Drama', 'History'],
      category: 'Movie',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 507086,
      title: 'Jurassic World Dominion',
      overview: 'Dinosaurs now live—and hunt—alongside humans all over the world.',
      posterPath: '/kAVRgw7GgK1CfYEJq8ME6EvRIgU.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.6,
      voteCount: 5800,
      releaseDate: '2022-06-10',
      genres: ['Adventure', 'Action', 'Sci-Fi'],
      category: 'Movie',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 414906,
      title: 'The Batman',
      overview: 'Batman ventures into Gotham City\'s underworld when a sadistic killer strikes.',
      posterPath: '/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      backdropPath: '/tRS6jvPM9qPrrnx2KRx3ew96Yot.jpg',
      voteAverage: 9.2,
      voteCount: 9200,
      releaseDate: '2022-03-04',
      genres: ['Action', 'Crime', 'Drama'],
      category: 'Movie',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 76600,
      title: 'Avatar: The Way of Water',
      overview: 'Set more than a decade after the events of the first film.',
      posterPath: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      backdropPath: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg',
      voteAverage: 9.8,
      voteCount: 11000,
      releaseDate: '2022-12-16',
      genres: ['Sci-Fi', 'Adventure', 'Action'],
      category: 'Movie',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 19995,
      title: 'Avatar',
      overview: 'In the 22nd century, a paraplegic Marine is dispatched to the moon Pandora.',
      posterPath: '/kyeqWdyUXW608qlYkRqosgbbJyK.jpg',
      backdropPath: '/vL5LR6WdxWPjC3U14697P14Zk9P.jpg',
      voteAverage: 9.5,
      voteCount: 29000,
      releaseDate: '2009-12-18',
      genres: ['Action', 'Adventure', 'Fantasy', 'Sci-Fi'],
      category: 'Movie',
      region: 'English',
    ),
    // ExploreMovieModel(
    //   id: 406759,
    //   title: 'Moonfall',
    //   overview: 'A mysterious force knocks the moon from its orbit around Earth.',
    //   posterPath: '/odVv1sqVs0KxBXiA8bnIBlP6EET.jpg',
    //   backdropPath: '/wPUgVBOXCvZK7ICkKLsvL8pxfSf.jpg',
    //   voteAverage: 9.4,
    //   voteCount: 2900,
    //   releaseDate: '2022-02-04',
    //   genres: ['Sci-Fi', 'Adventure', 'Action'],
    //   category: 'Movie',
    //   region: 'English',
    // ),
    ExploreMovieModel(
      id: 436270,
      title: 'Black Adam',
      overview: 'Nearly 5,000 years after he was bestowed with powers, Black Adam is freed.',
      posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
      backdropPath: '/bQXAqRx2Fgc46uCVWgoPz5L5Dtr.jpg',
      voteAverage: 9.6,
      voteCount: 5400,
      releaseDate: '2022-10-21',
      genres: ['Action', 'Fantasy', 'Sci-Fi'],
      category: 'Movie',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 361743,
      title: 'Top Gun: Maverick',
      overview: 'After thirty years, Maverick is pushing the envelope as a top naval aviator.',
      posterPath: '/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      backdropPath: '/odJ4hx6g6vBt4lBWKFD1tI8WS4x.jpg',
      voteAverage: 9.7,
      voteCount: 8200,
      releaseDate: '2022-05-27',
      genres: ['Action', 'Drama'],
      category: 'Movie',
      region: 'English',
    ),

    // --- TV Shows Category ---
    ExploreMovieModel(
      id: 66732,
      title: 'Stranger Things',
      overview: 'When a young boy vanishes, a small town uncovers a mystery.',
      posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
      backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
      voteAverage: 9.8,
      voteCount: 16000,
      releaseDate: '2022-05-27',
      genres: ['Sci-Fi', 'Drama', 'Mystery'],
      category: 'TV Shows',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 119051,
      title: 'Wednesday',
      overview: 'Wednesday Addams investigates twisted mysteries at Nevermore Academy.',
      posterPath: '/9PFonBhy4cQy7Jz20NpMygczOkv.jpg',
      backdropPath: '/iHSwvRVsRyxpX7FE7GbviaDvgGZ.jpg',
      voteAverage: 9.7,
      voteCount: 9780,
      releaseDate: '2022-11-23',
      genres: ['Comedy', 'Mystery', 'Sci-Fi'],
      category: 'TV Shows',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 71446,
      title: 'Money Heist',
      overview: 'Eight thieves take hostages in the Royal Mint of Spain.',
      posterPath: '/reEMJA1uzscCbkpeRJeTT2bjqUp.jpg',
      backdropPath: '/gFZriCkpJYsApPZEF3jhxL4yLzG.jpg',
      voteAverage: 9.6,
      voteCount: 17800,
      releaseDate: '2021-12-03',
      genres: ['Crime', 'Action', 'Drama'],
      category: 'TV Shows',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 71912,
      title: 'The Witcher',
      overview: 'Geralt of Rivia, a mutated monster-hunter for hire, journeys toward his destiny.',
      posterPath: '/7vjaCdMw15FEbXyLQTVa04URsPm.jpg',
      backdropPath: '/jBJWaqoSCiARWtfV0GlqHrcdidd.jpg',
      voteAverage: 9.5,
      voteCount: 6860,
      releaseDate: '2019-12-20',
      genres: ['Action', 'Adventure', 'Fantasy'],
      category: 'TV Shows',
      region: 'English',
    ),
    ExploreMovieModel(
      id: 110492,
      title: 'Halo',
      overview: 'Depicting an epic 26th-century conflict between humanity and an alien threat.',
      posterPath: '/4UmNhZCEu8Vt3byMvNxNEPyf8EY.jpg',
      backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
      voteAverage: 9.6,
      voteCount: 2240,
      releaseDate: '2022-03-24',
      genres: ['Sci-Fi', 'Action', 'Adventure'],
      category: 'TV Shows',
      region: 'English',
    ),

    // --- K-Drama Category ---
    ExploreMovieModel(
      id: 93405,
      title: 'Squid Game',
      overview: 'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games.',
      posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
      backdropPath: '/oaGvjB0DvdhX9ar97a6Cc9Qph2W.jpg',
      voteAverage: 9.8,
      voteCount: 13200,
      releaseDate: '2021-09-17',
      genres: ['Action', 'Mystery', 'Drama'],
      category: 'K-Drama',
      region: 'South Korean',
    ),
    ExploreMovieModel(
      id: 99966,
      title: 'All of Us Are Dead',
      overview: 'A high school becomes ground zero for a zombie virus outbreak.',
      posterPath: '/pTEFqAjLd5YTsMD6NSUxV6Dq7A6.jpg',
      backdropPath: '/hPea3jqhYmngcxpsveHICLFhKcu.jpg',
      voteAverage: 9.7,
      voteCount: 4400,
      releaseDate: '2022-01-28',
      genres: ['Action', 'Drama', 'Horror'],
      category: 'K-Drama',
      region: 'South Korean',
    ),
    ExploreMovieModel(
      id: 94796,
      title: 'Crash Landing on You',
      overview: 'A paragliding mishap drops a South Korean heiress into North Korea.',
      posterPath: '/fgBNLPr6mC8pxuR79ENAJY4nBmj.jpg',
      backdropPath: '/issNnZKtD56SfcP37UTzsNeyoBK.jpg',
      voteAverage: 9.7,
      voteCount: 2200,
      releaseDate: '2019-12-14',
      genres: ['Romance', 'Comedy', 'Drama'],
      category: 'K-Drama',
      region: 'South Korean',
    ),
    ExploreMovieModel(
      id: 117376,
      title: 'Vincenzo',
      overview: 'During a visit to his motherland, a Korean-Italian mafia lawyer confronts a conglomerate.',
      posterPath: '/qbkSS1cTjT4DzIwD44bdhTuYgdT.jpg',
      backdropPath: '/gMMnf8VRg3Z98WaFmOLr9Jk8pIs.jpg',
      voteAverage: 9.6,
      voteCount: 3100,
      releaseDate: '2021-02-20',
      genres: ['Crime', 'Comedy', 'Drama'],
      category: 'K-Drama',
      region: 'South Korean',
    ),
    ExploreMovieModel(
      id: 154825,
      title: 'Business Proposal',
      overview: 'In disguise on a blind date, Ha-ri discovers her date is the CEO of her company.',
      posterPath: '/iLh7L8ZuvgdxFaM9sImyv2iKYLe.jpg',
      backdropPath: '/cengzh6wjo938X0lFvI5pYJqWk8.jpg',
      voteAverage: 9.5,
      voteCount: 1800,
      releaseDate: '2022-02-28',
      genres: ['Comedy', 'Romance', 'Drama'],
      category: 'K-Drama',
      region: 'South Korean',
    ),

    // --- Anime Category ---
    ExploreMovieModel(
      id: 1429,
      title: 'Attack on Titan',
      overview: 'After his hometown is destroyed, young Eren Jaeger vows to cleanse the earth of the giant humanoids.',
      posterPath: '/rqbCbjB19amtOtFQbb3K2lgm2zv.jpg',
      backdropPath: '/mDeUmPe4MF35WWlAqj4QFX5UauJ.jpg',
      voteAverage: 9.8,
      voteCount: 6800,
      releaseDate: '2022-01-10',
      genres: ['Animation', 'Action', 'Fantasy'],
      category: 'Anime',
      region: 'Japanese',
    ),
    ExploreMovieModel(
      id: 610150,
      title: 'Dragon Ball Super: Super Hero',
      overview: 'The Red Ribbon Army from Goku\'s past has returned with two new androids.',
      posterPath: '/uR0FopHrAjDlG5q6PZB07a1JOva.jpg',
      backdropPath: '/xs9zz3lkLXRSL7gbNYL2WOS6WqL.jpg',
      voteAverage: 9.6,
      voteCount: 3200,
      releaseDate: '2022-06-11',
      genres: ['Animation', 'Action', 'Sci-Fi'],
      category: 'Anime',
      region: 'Japanese',
    ),
    // ExploreMovieModel(
    //   id: 120089,
    //   title: 'Spy x Family',
    //   overview: 'A spy on an undercover mission gets married and adopts a child as part of his cover.',
    //   posterPath: '/3rSSpDlFeoOyvQkFz8r8Q3aRzwQ.jpg',
    //   backdropPath: '/ge9hTSzmInLcvqzgTCRzyqC6Tmr.jpg',
    //   voteAverage: 9.5,
    //   voteCount: 1900,
    //   releaseDate: '2022-04-09',
    //   genres: ['Animation', 'Comedy', 'Action'],
    //   category: 'Anime',
    //   region: 'Japanese',
    // ),
    ExploreMovieModel(
      id: 85937,
      title: 'Demon Slayer',
      overview: 'Tanjiro Kamado sets out to become a demon slayer to avenge his family and cure his sister.',
      posterPath: '/xUfRZu2mi8jH6SzQEJGP6tjBuYj.jpg',
      backdropPath: '/nTvM4mhqNlHIvUkI1gVnW6XP7GG.jpg',
      voteAverage: 9.8,
      voteCount: 7400,
      releaseDate: '2022-12-05',
      genres: ['Animation', 'Action', 'Fantasy'],
      category: 'Anime',
      region: 'Japanese',
    ),
  ];
}

