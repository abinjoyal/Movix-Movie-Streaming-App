import '../entities/movie_details.dart';
import '../repositories/movie_details_repository.dart';

class MovieCommentsUseCases {
  final MovieDetailsRepository _repository;

  const MovieCommentsUseCases(this._repository);

  Future<List<MovieComment>> getComments(int movieId) =>
      _repository.getComments(movieId);

  Future<MovieComment> addComment({
    required int movieId,
    required String content,
    String? parentCommentId,
    String? username,
    String? avatarUrl,
  }) {
    return _repository.addComment(
      movieId: movieId,
      content: content,
      parentCommentId: parentCommentId,
      username: username,
      avatarUrl: avatarUrl,
    );
  }

  Future<void> toggleLike({
    required String commentId,
    required bool currentlyLiked,
  }) {
    return _repository.toggleLikeComment(
      commentId: commentId,
      currentlyLiked: currentlyLiked,
    );
  }

  Future<void> deleteComment(String commentId) =>
      _repository.deleteComment(commentId);
}

