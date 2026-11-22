import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/tmdb_api_client.dart';
import '../../../../core/api/tvmaze_api_client.dart';
import '../../data/datasources/explore_remote_datasource.dart';
import '../../data/repositories/explore_repository_impl.dart';
import '../../domain/entities/explore_movie.dart';
import '../../domain/repositories/explore_repository.dart';
import '../../domain/usecases/filter_movies.dart';
import '../../domain/usecases/search_movies.dart';

// --- Data & Domain Providers ---

final exploreRemoteDataSourceProvider = Provider<ExploreRemoteDataSource>((ref) {
  return ExploreRemoteDataSourceImpl(
    ref.watch(tmdbApiClientProvider),
    ref.watch(tvmazeApiClientProvider),
  );
});

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepositoryImpl(ref.watch(exploreRemoteDataSourceProvider));
});

final searchMoviesUseCaseProvider = Provider<SearchMoviesUseCase>((ref) {
  return SearchMoviesUseCase(ref.watch(exploreRepositoryProvider));
});

final filterMoviesUseCaseProvider = Provider<FilterMoviesUseCase>((ref) {
  return FilterMoviesUseCase(ref.watch(exploreRepositoryProvider));
});

// --- Explore State & Notifier ---

class ExploreFilterState {
  final String? category;
  final List<String> regions;
  final List<String> genres;
  final String? period;
  final String? sortBy;

  const ExploreFilterState({
    this.category,
    this.regions = const [],
    this.genres = const [],
    this.period,
    this.sortBy = 'Popularity',
  });

  bool get hasActiveFilters =>
      category != null ||
      regions.isNotEmpty ||
      genres.isNotEmpty ||
      (period != null && period != 'All Periods');

  List<String> get activeFilterChips {
    final chips = <String>[];
    if (category != null && category!.isNotEmpty) chips.add(category!);
    chips.addAll(regions);
    chips.addAll(genres);
    if (period != null && period!.isNotEmpty && period != 'All Periods') {
      chips.add(period!);
    }
    return chips;
  }

  ExploreFilterState copyWith({
    String? Function()? category,
    List<String>? regions,
    List<String>? genres,
    String? Function()? period,
    String? sortBy,
  }) {
    return ExploreFilterState(
      category: category != null ? category() : this.category,
      regions: regions ?? this.regions,
      genres: genres ?? this.genres,
      period: period != null ? period() : this.period,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class ExploreState {
  final bool isLoading;
  final bool isSearchFocused;
  final String searchQuery;
  final List<ExploreMovie> movies;
  final List<ExploreMovie> topSearches;
  final ExploreFilterState filters;
  final String? errorMessage;

  const ExploreState({
    this.isLoading = false,
    this.isSearchFocused = false,
    this.searchQuery = '',
    this.movies = const [],
    this.topSearches = const [],
    this.filters = const ExploreFilterState(),
    this.errorMessage,
  });

  bool get isQueryEmpty => searchQuery.trim().isEmpty;
  bool get showTopSearches => isSearchFocused && isQueryEmpty;
  bool get showEmptyState => !isLoading && !showTopSearches && movies.isEmpty;

  ExploreState copyWith({
    bool? isLoading,
    bool? isSearchFocused,
    String? searchQuery,
    List<ExploreMovie>? movies,
    List<ExploreMovie>? topSearches,
    ExploreFilterState? filters,
    String? errorMessage,
  }) {
    return ExploreState(
      isLoading: isLoading ?? this.isLoading,
      isSearchFocused: isSearchFocused ?? this.isSearchFocused,
      searchQuery: searchQuery ?? this.searchQuery,
      movies: movies ?? this.movies,
      topSearches: topSearches ?? this.topSearches,
      filters: filters ?? this.filters,
      errorMessage: errorMessage,
    );
  }
}

class ExploreNotifier extends StateNotifier<ExploreState> {
  final SearchMoviesUseCase _searchMovies;
  final FilterMoviesUseCase _filterMovies;
  final ExploreRepository _repository;
  Timer? _debounceTimer;

  ExploreNotifier(
    this._searchMovies,
    this._filterMovies,
    this._repository,
  ) : super(const ExploreState()) {
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      final topSearches = await _repository.getTopSearches();
      final initialMovies = await _filterMovies(
        sortBy: state.filters.sortBy,
      );
      state = state.copyWith(
        isLoading: false,
        topSearches: topSearches,
        movies: initialMovies,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load explore movies',
      );
    }
  }

  void setSearchFocused(bool isFocused) {
    state = state.copyWith(isSearchFocused: isFocused);
  }

  void onSearchQueryChanged(String query) {
    state = state.copyWith(searchQuery: query);

    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      applyCurrentFilters();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _executeSearch(query.trim());
    });
  }

  Future<void> _executeSearch(String query) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await _searchMovies(query);
      state = state.copyWith(isLoading: false, movies: results);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        movies: [],
        errorMessage: 'Failed to search movies',
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    applyCurrentFilters();
  }

  Future<void> applyFilters(ExploreFilterState newFilters) async {
    state = state.copyWith(
      filters: newFilters,
      isLoading: true,
      searchQuery: '',
    );

    try {
      final results = await _filterMovies(
        category: newFilters.category,
        regions: newFilters.regions,
        genres: newFilters.genres,
        period: newFilters.period,
        sortBy: newFilters.sortBy,
      );
      state = state.copyWith(isLoading: false, movies: results);
    } catch (e) {
      state = state.copyWith(isLoading: false, movies: []);
    }
  }

  void removeFilterChip(String chip) {
    final current = state.filters;
    String? newCat = current.category == chip ? null : current.category;
    List<String> newRegions = List.from(current.regions)..remove(chip);
    List<String> newGenres = List.from(current.genres)..remove(chip);
    String? newPeriod = current.period == chip ? null : current.period;

    applyFilters(
      current.copyWith(
        category: () => newCat,
        regions: newRegions,
        genres: newGenres,
        period: () => newPeriod,
      ),
    );
  }

  void resetFilters() {
    applyFilters(const ExploreFilterState());
  }

  Future<void> applyCurrentFilters() async {
    applyFilters(state.filters);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final exploreProvider =
    StateNotifierProvider<ExploreNotifier, ExploreState>((ref) {
  return ExploreNotifier(
    ref.watch(searchMoviesUseCaseProvider),
    ref.watch(filterMoviesUseCaseProvider),
    ref.watch(exploreRepositoryProvider),
  );
});

