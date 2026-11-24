import '../entities/movie.dart';
import '../repositories/home_repository.dart';

class GetTopRatedMoviesUseCase {
  final HomeRepository repository;

  GetTopRatedMoviesUseCase(this.repository);

  Future<List<Movie>> call() {
    return repository.getTopRatedMovies();
  }
}

