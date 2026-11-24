import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/tmdb_api_client.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_now_playing_movies.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/get_trending_movies.dart';

// --- Data & Domain Providers ---

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(ref.watch(tmdbApiClientProvider));
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));
});

final getTrendingMoviesUseCaseProvider =
    Provider<GetTrendingMoviesUseCase>((ref) {
  return GetTrendingMoviesUseCase(ref.watch(homeRepositoryProvider));
});

final getTopRatedMoviesUseCaseProvider =
    Provider<GetTopRatedMoviesUseCase>((ref) {
  return GetTopRatedMoviesUseCase(ref.watch(homeRepositoryProvider));
});

final getNowPlayingMoviesUseCaseProvider =
    Provider<GetNowPlayingMoviesUseCase>((ref) {
  return GetNowPlayingMoviesUseCase(ref.watch(homeRepositoryProvider));
});

final getPopularMoviesUseCaseProvider =
    Provider<GetPopularMoviesUseCase>((ref) {
  return GetPopularMoviesUseCase(ref.watch(homeRepositoryProvider));
});

// --- Home State & Notifier ---

class HomeState {
  final bool isLoading;
  final List<Movie> banners;
  final List<Movie> trendingMovies;
  final List<Movie> top10Movies;
  final List<Movie> newReleases;
  final int activeBannerIndex;
  final int selectedNavIndex;
  final String? errorMessage;

  const HomeState({
    this.isLoading = true,
    this.banners = const [],
    this.trendingMovies = const [],
    this.top10Movies = const [],
    this.newReleases = const [],
    this.activeBannerIndex = 0,
    this.selectedNavIndex = 0,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Movie>? banners,
    List<Movie>? trendingMovies,
    List<Movie>? top10Movies,
    List<Movie>? newReleases,
    int? activeBannerIndex,
    int? selectedNavIndex,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      banners: banners ?? this.banners,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      top10Movies: top10Movies ?? this.top10Movies,
      newReleases: newReleases ?? this.newReleases,
      activeBannerIndex: activeBannerIndex ?? this.activeBannerIndex,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      errorMessage: errorMessage,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final GetPopularMoviesUseCase _getPopularMovies;
  final GetTrendingMoviesUseCase _getTrendingMovies;
  final GetTopRatedMoviesUseCase _getTopRatedMovies;
  final GetNowPlayingMoviesUseCase _getNowPlayingMovies;

  HomeNotifier(
    this._getPopularMovies,
    this._getTrendingMovies,
    this._getTopRatedMovies,
    this._getNowPlayingMovies,
  ) : super(const HomeState()) {
    loadHomeData();
  }

  void setBannerIndex(int index) {
    state = state.copyWith(activeBannerIndex: index);
  }

  void setNavIndex(int index) {
    state = state.copyWith(selectedNavIndex: index);
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final results = await Future.wait([
        _getPopularMovies(),
        _getTrendingMovies(),
        _getTopRatedMovies(),
        _getNowPlayingMovies(),
      ]);

      final popular = results[0];
      final trending = results[1];
      final topRated = results[2];
      final nowPlaying = results[3];

      state = state.copyWith(
        isLoading: false,
        banners: popular.take(5).toList(),
        trendingMovies: trending,
        top10Movies: topRated.take(10).toList(),
        newReleases: nowPlaying,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load movie feed.',
      );
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    ref.watch(getPopularMoviesUseCaseProvider),
    ref.watch(getTrendingMoviesUseCaseProvider),
    ref.watch(getTopRatedMoviesUseCaseProvider),
    ref.watch(getNowPlayingMoviesUseCaseProvider),
  );
});

