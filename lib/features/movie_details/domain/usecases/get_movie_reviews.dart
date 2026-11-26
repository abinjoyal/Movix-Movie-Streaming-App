import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieReviewsUseCase {
  final MovieDetailsRepository _repository;

  const GetMovieReviewsUseCase(this._repository);

  Future<List<MovieReview>> call(int movieId, {int page = 1}) =>
      _repository.getMovieReviews(movieId, page: page);
}

