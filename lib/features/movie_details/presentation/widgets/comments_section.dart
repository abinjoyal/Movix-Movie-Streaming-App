import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/movie_details.dart';

class CommentsSection extends StatefulWidget {
  final List<MovieComment> comments;
  final int totalCommentsCount;
  final bool showAllComments;
  final bool isSubmitting;
  final String? currentUserId;
  final MovieComment? replyingTo;
  final VoidCallback onToggleSeeAll;
  final VoidCallback? onOpenFullComments;
  final ValueChanged<MovieComment?> onSelectReply;
  final Future<String?> Function(String content) onSubmitComment;
  final Future<String?> Function(MovieComment comment) onToggleLike;
  final Future<String?> Function(String commentId) onDeleteComment;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.totalCommentsCount,
    required this.showAllComments,
    required this.isSubmitting,
    required this.currentUserId,
    required this.replyingTo,
    required this.onToggleSeeAll,
    this.onOpenFullComments,
    required this.onSelectReply,
    required this.onSubmitComment,
    required this.onToggleLike,
    required this.onDeleteComment,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final error = await widget.onSubmitComment(_controller.text);
    if (!mounted) return;
    if (error == null) {
      _controller.clear();
      _focusNode.unfocus();
    } else {
      _showFeedback(error);
    }
  }

  Future<void> _handleLike(MovieComment comment) async {
    final error = await widget.onToggleLike(comment);
    if (mounted && error != null) _showFeedback(error);
  }

  Future<void> _handleDelete(String commentId) async {
    final error = await widget.onDeleteComment(commentId);
    if (mounted && error != null) _showFeedback(error);
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final visibleComments = widget.showAllComments
        ? widget.comments
        : widget.comments.take(6).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.totalCommentsCount} Comments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            InkWell(
              onTap: widget.onOpenFullComments ?? widget.onToggleSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        CommentInputBar(
          controller: _controller,
          focusNode: _focusNode,
          isSubmitting: widget.isSubmitting,
          replyingTo: widget.replyingTo,
          onCancelReply: () => widget.onSelectReply(null),
          onSend: _handleSend,
        ),
        const SizedBox(height: 18),
        if (visibleComments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 38,
                  color: textSecondary,
                ),
                const SizedBox(height: 10),
                Text(
                  'No comments yet. Be the first to share your thoughts!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textSecondary, fontSize: 13.5),
                ),
              ],
            ),
          )
        else
          ...visibleComments.map(
            (comment) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CommentThreadTile(
                comment: comment,
                currentUserId: widget.currentUserId,
                onLike: _handleLike,
                onReply: (target) {
                  widget.onSelectReply(target);
                  _focusNode.requestFocus();
                },
                onDelete: _handleDelete,
              ),
            ),
          ),
      ],
    );
  }
}

/// Reusable comment input bar shared between Tab 3 and Full Comments Screen (Figma 39 & 40).
class CommentInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSubmitting;
  final MovieComment? replyingTo;
  final VoidCallback onCancelReply;
  final VoidCallback onSend;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isSubmitting,
    required this.replyingTo,
    required this.onCancelReply,
    required this.onSend,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  static const List<String> _quickEmojis = ['🔥', '❤️', '👏', '😂', '😮', '🎬'];
  bool _showEmojiRow = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() => _isFocused = widget.focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final inputFill = _isFocused
        ? AppColors.primaryRed.withValues(alpha: 0.06)
        : (isDark
            ? AppColors.darkSurfaceElevated
            : AppColors.lightSurfaceElevated);
    final borderColor = _isFocused
        ? AppColors.primaryRed
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyingTo != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Replying to ${widget.replyingTo!.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primaryRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                InkWell(
                  onTap: widget.onCancelReply,
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ),
        if (_showEmojiRow)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _quickEmojis.map((emoji) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    final text = widget.controller.text;
                    widget.controller.text = '$text$emoji';
                    widget.controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: widget.controller.text.length),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => widget.isSubmitting ? null : widget.onSend(),
                decoration: InputDecoration(
                  hintText: widget.replyingTo != null
                      ? 'Write a reply...'
                      : 'Add comment...',
                  hintStyle: TextStyle(color: textSecondary, fontSize: 13.5),
                  filled: true,
                  fillColor: inputFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Quick emoji',
                    onPressed: () =>
                        setState(() => _showEmojiRow = !_showEmojiRow),
                    icon: Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      size: 20,
                      color:
                          _isFocused ? AppColors.primaryRed : textSecondary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: AppColors.primaryRed,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                onPressed: widget.isSubmitting ? null : widget.onSend,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                ),
                icon: widget.isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 19),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Reusable threaded comment tile shared between Tab 3 and Full Comments Screen.
class CommentThreadTile extends StatelessWidget {
  final MovieComment comment;
  final String? currentUserId;
  final ValueChanged<MovieComment> onLike;
  final ValueChanged<MovieComment> onReply;
  final ValueChanged<String> onDelete;

  const CommentThreadTile({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.onLike,
    required this.onReply,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentCard(
          comment: comment,
          isOwner: currentUserId != null && currentUserId == comment.userId,
          onLike: () => onLike(comment),
          onReply: () => onReply(comment),
          onDelete: () => onDelete(comment.id),
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 10),
            child: Column(
              children: comment.replies
                  .map(
                    (reply) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _CommentCard(
                        comment: reply,
                        isReply: true,
                        isOwner: currentUserId != null &&
                            currentUserId == reply.userId,
                        onLike: () => onLike(reply),
                        onReply: () => onReply(comment),
                        onDelete: () => onDelete(reply.id),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  final MovieComment comment;
  final bool isOwner;
  final bool isReply;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onDelete;

  const _CommentCard({
    required this.comment,
    required this.isOwner,
    this.isReply = false,
    required this.onLike,
    required this.onReply,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final avatarBg =
        isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;
    final avatarSize = isReply ? 32.0 : 40.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: AppCachedImage(
                imageUrl: comment.avatarUrl,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
                customErrorWidget: Container(
                  width: avatarSize,
                  height: avatarSize,
                  color: avatarBg,
                  child: Icon(
                    Icons.person_rounded,
                    size: avatarSize * 0.55,
                    color: textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                comment.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
            if (isOwner)
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.pending_outlined,
                  size: 20,
                  color: textSecondary,
                ),
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text('Delete Comment'),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          comment.content,
          style: TextStyle(fontSize: 13, height: 1.4, color: textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            InkWell(
              onTap: onLike,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      comment.isLikedByCurrentUser
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: comment.isLikedByCurrentUser
                          ? AppColors.primaryRed
                          : textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${comment.likesCount}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 18),
            Text(
              _formatRelativeTime(comment.createdAt),
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
            const SizedBox(width: 18),
            InkWell(
              onTap: onReply,
              child: Text(
                'Reply',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatRelativeTime(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays} days ago';
    final months = diff.inDays ~/ 30;
    return months == 1 ? '1 month ago' : '$months months ago';
  }
}
