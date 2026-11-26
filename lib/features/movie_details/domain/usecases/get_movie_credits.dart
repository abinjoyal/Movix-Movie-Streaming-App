import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieCreditsUseCase {
  final MovieDetailsRepository _repository;

  const GetMovieCreditsUseCase(this._repository);

  Future<List<CastMember>> call(int movieId, {bool isTvShow = false}) =>
      _repository.getMovieCredits(movieId, isTvShow: isTvShow);
}

