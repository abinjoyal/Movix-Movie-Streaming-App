import '../entities/explore_movie.dart';
import '../repositories/explore_repository.dart';

class FilterMoviesUseCase {
  final ExploreRepository _repository;

  FilterMoviesUseCase(this._repository);

  Future<List<ExploreMovie>> call({
    String? category,
    List<String>? regions,
    List<String>? genres,
    String? period,
    String? sortBy,
  }) async {
    return await _repository.filterMovies(
      category: category,
      regions: regions,
      genres: genres,
      period: period,
      sortBy: sortBy,
    );
  }
}

