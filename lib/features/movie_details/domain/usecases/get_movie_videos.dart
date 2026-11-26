import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetMovieVideosUseCase {
  final MovieDetailsRepository _repository;

  const GetMovieVideosUseCase(this._repository);

  Future<List<MovieTrailer>> call(int movieId, {bool isTvShow = false}) =>
      _repository.getMovieVideos(movieId, isTvShow: isTvShow);
}

