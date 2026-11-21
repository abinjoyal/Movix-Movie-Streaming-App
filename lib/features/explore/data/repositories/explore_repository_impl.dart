import '../../domain/entities/explore_movie.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_datasource.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource _remoteDataSource;

  ExploreRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ExploreMovie>> searchMovies(String query) async {
    return await _remoteDataSource.searchMovies(query);
  }

  @override
  Future<List<ExploreMovie>> filterMovies({
    String? category,
    List<String>? regions,
    List<String>? genres,
    String? period,
    String? sortBy,
  }) async {
    return await _remoteDataSource.filterMovies(
      category: category,
      regions: regions,
      genres: genres,
      period: period,
      sortBy: sortBy,
    );
  }

  @override
  Future<List<ExploreMovie>> getTopSearches() async {
    return await _remoteDataSource.getTopSearches();
  }
}

