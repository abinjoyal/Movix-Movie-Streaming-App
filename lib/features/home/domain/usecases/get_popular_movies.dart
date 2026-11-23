import '../entities/movie.dart';
import '../repositories/home_repository.dart';

class GetPopularMoviesUseCase {
  final HomeRepository repository;

  GetPopularMoviesUseCase(this.repository);

  Future<List<Movie>> call() {
    return repository.getPopularMovies();
  }
}

