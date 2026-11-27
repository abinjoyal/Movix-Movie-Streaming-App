import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../providers/movie_details_provider.dart';

/// Displays movies/shows associated with a selected cast or crew member (Figma Screen 38).
class CastMoviesScreen extends ConsumerStatefulWidget {
  final int personId;
  final String personName;
  final bool isTvMaze;

  const CastMoviesScreen({
    super.key,
    required this.personId,
    required this.personName,
    this.isTvMaze = false,
  });

  @override
  ConsumerState<CastMoviesScreen> createState() => _CastMoviesScreenState();
}

class _CastMoviesScreenState extends ConsumerState<CastMoviesScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    final args = (
      personId: widget.personId,
      personName: widget.personName,
      isTvMaze: widget.isTvMaze,
    );
    final moviesAsync = ref.watch(castMoviesProvider(args));

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) => setState(() => _query = value.trim()),
                style: TextStyle(color: textPrimary, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Filter ${widget.personName} titles...',
                  hintStyle: TextStyle(color: textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              )
            : Text(
                widget.isTvMaze
                    ? '${widget.personName} Shows'
                    : '${widget.personName} Movies',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _query = '';
                }
              });
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: moviesAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Unable to load titles for ${widget.personName}.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => ref.invalidate(castMoviesProvider(args)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (movies) {
          final filtered = _query.isEmpty
              ? movies
              : movies
                  .where(
                    (m) => m.title.toLowerCase().contains(_query.toLowerCase()),
                  )
                  .toList();

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                'No matching titles found.',
                style: TextStyle(color: textSecondary, fontSize: 14),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.68,
            ),
            itemCount: filtered.length,
            itemBuilder: (_, index) {
              final movie = filtered[index];
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => context.push(
                  movie.isTvMaze
                      ? RoutePaths.tvDetailsPath(movie.id)
                      : RoutePaths.movieDetailsPath(movie.id),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppCachedImage(
                        imageUrl: movie.fullPosterUrl,
                        fit: BoxFit.cover,
                        errorIcon: Icons.movie_creation_outlined,
                        errorIconSize: 36,
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            movie.formattedRating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

