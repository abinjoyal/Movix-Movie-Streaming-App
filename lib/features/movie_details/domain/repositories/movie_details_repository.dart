import '../entities/movie_details.dart';

/// Repository contract for Movie Details, TMDB metadata, and Supabase comments.
abstract class MovieDetailsRepository {
  Future<MovieDetails> getMovieDetails(int movieId, {bool isTvShow = false});
  Future<List<CastMember>> getMovieCredits(int movieId, {bool isTvShow = false});
  Future<List<MovieTrailer>> getMovieVideos(int movieId, {bool isTvShow = false});
  Future<List<SimilarMovie>> getSimilarAndRecommendedMovies(
    int movieId, {
    int page = 1,
    bool isTvShow = false,
  });
  Future<List<MovieReview>> getMovieReviews(int movieId, {int page = 1});
  Future<List<SimilarMovie>> getPersonMovies(
    int personId, {
    bool isTvMaze = false,
    String? personName,
  });

  // Supabase comments
  Future<List<MovieComment>> getComments(int movieId);
  Future<MovieComment> addComment({
    required int movieId,
    required String content,
    String? parentCommentId,
    String? username,
    String? avatarUrl,
  });
  Future<void> toggleLikeComment({
    required String commentId,
    required bool currentlyLiked,
  });
  Future<void> deleteComment(String commentId);
}

