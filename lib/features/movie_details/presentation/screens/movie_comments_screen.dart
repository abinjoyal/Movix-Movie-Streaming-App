import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/supabase/supabase_service.dart';
import '../../domain/entities/movie_details.dart';
import '../providers/movie_details_provider.dart';
import '../widgets/comments_section.dart';

/// Full-screen Comments view with sticky keyboard-aware input matching Figma Screens 39 & 40.
class MovieCommentsScreen extends ConsumerStatefulWidget {
  final int movieId;
  final bool isTvShow;

  const MovieCommentsScreen({
    super.key,
    required this.movieId,
    this.isTvShow = false,
  });

  @override
  ConsumerState<MovieCommentsScreen> createState() =>
      _MovieCommentsScreenState();
}

class _MovieCommentsScreenState extends ConsumerState<MovieCommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _sortByTopLiked = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSend(MovieDetailsNotifier notifier) async {
    final error = await notifier.addComment(_controller.text);
    if (!mounted) return;
    if (error == null) {
      _controller.clear();
      _focusNode.unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _handleLike(
    MovieDetailsNotifier notifier,
    MovieComment comment,
  ) async {
    final error = await notifier.toggleLikeComment(comment);
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  Future<void> _handleDelete(
    MovieDetailsNotifier notifier,
    String commentId,
  ) async {
    final error = await notifier.deleteComment(commentId);
    if (mounted && error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg =
        isDark ? AppColors.darkBackground : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    final args = (id: widget.movieId, isTvShow: widget.isTvShow);
    final state = ref.watch(movieDetailsProvider(args));
    final notifier = ref.read(movieDetailsProvider(args).notifier);
    final currentUserId =
        ref.watch(supabaseClientProvider)?.auth.currentUser?.id;

    final sortedComments = List<MovieComment>.from(state.comments);
    if (_sortByTopLiked) {
      sortedComments.sort((a, b) => b.likesCount.compareTo(a.likesCount));
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Text(
          '${state.totalCommentsCount} Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.pending_outlined, color: textPrimary),
            onSelected: (value) {
              setState(() => _sortByTopLiked = value == 'top');
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'latest', child: Text('Newest First')),
              PopupMenuItem(value: 'top', child: Text('Top Liked')),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: sortedComments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 42,
                            color: textSecondary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No comments yet. Start the conversation!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                    itemCount: sortedComments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 18),
                    itemBuilder: (_, index) {
                      return CommentThreadTile(
                        comment: sortedComments[index],
                        currentUserId: currentUserId,
                        onLike: (c) => _handleLike(notifier, c),
                        onReply: (target) {
                          notifier.setReplyingTo(target);
                          _focusNode.requestFocus();
                        },
                        onDelete: (id) => _handleDelete(notifier, id),
                      );
                    },
                  ),
          ),
          Divider(height: 1, color: dividerColor),
          SafeArea(
            top: false,
            child: Container(
              color: scaffoldBg,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: CommentInputBar(
                controller: _controller,
                focusNode: _focusNode,
                isSubmitting: state.isSubmittingComment,
                replyingTo: state.replyingTo,
                onCancelReply: () => notifier.setReplyingTo(null),
                onSend: () => _handleSend(notifier),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

