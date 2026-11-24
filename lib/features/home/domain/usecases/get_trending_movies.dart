import '../entities/movie.dart';
import '../repositories/home_repository.dart';

class GetTrendingMoviesUseCase {
  final HomeRepository repository;

  GetTrendingMoviesUseCase(this.repository);

  Future<List<Movie>> call() {
    return repository.getTrendingMovies();
  }
}

