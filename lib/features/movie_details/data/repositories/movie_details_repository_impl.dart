import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_details_repository.dart';
import '../datasources/movie_details_remote_datasource.dart';

class MovieDetailsRepositoryImpl implements MovieDetailsRepository {
  final MovieDetailsRemoteDataSource _remoteDataSource;

  const MovieDetailsRepositoryImpl(this._remoteDataSource);

  @override
  Future<MovieDetails> getMovieDetails(int movieId, {bool isTvShow = false}) =>
      _remoteDataSource.getMovieDetails(movieId, isTvShow: isTvShow);

  @override
  Future<List<CastMember>> getMovieCredits(
    int movieId, {
    bool isTvShow = false,
  }) =>
      _remoteDataSource.getMovieCredits(movieId, isTvShow: isTvShow);

  @override
  Future<List<MovieTrailer>> getMovieVideos(
    int movieId, {
    bool isTvShow = false,
  }) =>
      _remoteDataSource.getMovieVideos(movieId, isTvShow: isTvShow);

  @override
  Future<List<SimilarMovie>> getSimilarAndRecommendedMovies(
    int movieId, {
    int page = 1,
    bool isTvShow = false,
  }) =>
      _remoteDataSource.getSimilarAndRecommendedMovies(
        movieId,
        page: page,
        isTvShow: isTvShow,
      );

  @override
  Future<List<MovieReview>> getMovieReviews(int movieId, {int page = 1}) =>
      _remoteDataSource.getMovieReviews(movieId, page: page);

  @override
  Future<List<SimilarMovie>> getPersonMovies(
    int personId, {
    bool isTvMaze = false,
    String? personName,
  }) =>
      _remoteDataSource.getPersonMovies(
        personId,
        isTvMaze: isTvMaze,
        personName: personName,
      );

  @override
  Future<List<MovieComment>> getComments(int movieId) =>
      _remoteDataSource.getComments(movieId);

  @override
  Future<MovieComment> addComment({
    required int movieId,
    required String content,
    String? parentCommentId,
    String? username,
    String? avatarUrl,
  }) =>
      _remoteDataSource.addComment(
        movieId: movieId,
        content: content,
        parentCommentId: parentCommentId,
        username: username,
        avatarUrl: avatarUrl,
      );

  @override
  Future<void> toggleLikeComment({
    required String commentId,
    required bool currentlyLiked,
  }) =>
      _remoteDataSource.toggleLikeComment(
        commentId: commentId,
        currentlyLiked: currentlyLiked,
      );

  @override
  Future<void> deleteComment(String commentId) =>
      _remoteDataSource.deleteComment(commentId);
}

