import 'package:flutter/material.dart';
import '../../domain/entities/explore_movie.dart';
import 'explore_movie_card.dart';

/// 2-column responsive grid displaying explore movie cards with 2:3 aspect ratio.
class MovieGrid extends StatelessWidget {
  final List<ExploreMovie> movies;
  final void Function(ExploreMovie movie)? onMovieTap;

  const MovieGrid({
    super.key,
    required this.movies,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ExploreMovieCard(
          movie: movie,
          onTap: () => onMovieTap?.call(movie),
        );
      },
    );
  }
}

