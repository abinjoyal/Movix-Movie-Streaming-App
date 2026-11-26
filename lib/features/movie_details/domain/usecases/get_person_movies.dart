import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class GetPersonMoviesUseCase {
  final MovieDetailsRepository _repository;

  const GetPersonMoviesUseCase(this._repository);

  Future<List<SimilarMovie>> call(
    int personId, {
    bool isTvMaze = false,
    String? personName,
  }) =>
      _repository.getPersonMovies(
        personId,
        isTvMaze: isTvMaze,
        personName: personName,
      );
}

