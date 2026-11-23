import '../../domain/entities/movie.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Movie>> getTrendingMovies() {
    return remoteDataSource.getTrendingMovies();
  }

  @override
  Future<List<Movie>> getTopRatedMovies() {
    return remoteDataSource.getTopRatedMovies();
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() {
    return remoteDataSource.getNowPlayingMovies();
  }

  @override
  Future<List<Movie>> getPopularMovies() {
    return remoteDataSource.getPopularMovies();
  }
}

