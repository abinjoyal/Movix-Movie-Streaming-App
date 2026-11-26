import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieDetailsUseCase {
  final MovieDetailsRepository _repository;

  const GetMovieDetailsUseCase(this._repository);

  Future<MovieDetails> call(int movieId, {bool isTvShow = false}) =>
      _repository.getMovieDetails(movieId, isTvShow: isTvShow);
}

