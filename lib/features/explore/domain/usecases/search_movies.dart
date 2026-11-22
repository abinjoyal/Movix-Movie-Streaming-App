import '../entities/explore_movie.dart';
import '../repositories/explore_repository.dart';

class SearchMoviesUseCase {
  final ExploreRepository _repository;

  SearchMoviesUseCase(this._repository);

  Future<List<ExploreMovie>> call(String query) async {
    return await _repository.searchMovies(query);
  }
}

