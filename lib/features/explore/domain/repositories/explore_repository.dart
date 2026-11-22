import '../entities/explore_movie.dart';

abstract class ExploreRepository {
  /// Search movies dynamically with debounced query.
  Future<List<ExploreMovie>> searchMovies(String query);

  /// Discover movies with advanced filters (categories, regions, genres, period, sort).
  Future<List<ExploreMovie>> filterMovies({
    String? category,
    List<String>? regions,
    List<String>? genres,
    String? period,
    String? sortBy,
  });

  /// Get popular movies for "Top Searches" suggestions.
  Future<List<ExploreMovie>> getTopSearches();
}

