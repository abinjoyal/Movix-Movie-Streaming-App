import '../../domain/entities/movie_details.dart';

class MovieCommentModel extends MovieComment {
  const MovieCommentModel({
    required super.id,
    required super.movieId,
    required super.userId,
    required super.username,
    required super.avatarUrl,
    required super.content,
    required super.createdAt,
    super.likesCount,
    super.isLikedByCurrentUser,
    super.parentCommentId,
    super.replies,
  });

  factory MovieCommentModel.fromJson(
    Map<String, dynamic> json, {
    bool isLikedByCurrentUser = false,
    List<MovieComment> replies = const [],
  }) {
    return MovieCommentModel(
      id: (json['id'] ?? '').toString(),
      movieId: (json['movie_id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] ?? '').toString(),
      username: (json['username'] ?? 'Movix User').toString(),
      avatarUrl: (json['avatar_url'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
              DateTime.now(),
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      isLikedByCurrentUser: isLikedByCurrentUser,
      parentCommentId: json['parent_comment_id']?.toString(),
      replies: replies,
    );
  }
}

