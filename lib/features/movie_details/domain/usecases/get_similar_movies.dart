import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetSimilarMoviesUseCase {
  final MovieDetailsRepository _repository;

  const GetSimilarMoviesUseCase(this._repository);

  Future<List<SimilarMovie>> call(
    int movieId, {
    int page = 1,
    bool isTvShow = false,
  }) =>
      _repository.getSimilarAndRecommendedMovies(
        movieId,
        page: page,
        isTvShow: isTvShow,
      );
}

