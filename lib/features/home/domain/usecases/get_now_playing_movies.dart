import '../entities/movie.dart';
import '../repositories/home_repository.dart';

class GetNowPlayingMoviesUseCase {
  final HomeRepository repository;

  GetNowPlayingMoviesUseCase(this.repository);

  Future<List<Movie>> call() {
    return repository.getNowPlayingMovies();
  }
}

