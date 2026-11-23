import '../entities/movie.dart';

/// Contract defining movie queries for the Home module.
abstract class HomeRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getTopRatedMovies();
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getPopularMovies();
}

