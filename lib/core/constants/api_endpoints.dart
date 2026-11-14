import '../config/env_config.dart';

/// Centralized API endpoint URLs and image CDN paths for Movix.
class ApiEndpoints {
  ApiEndpoints._();

  // TMDB Base URL (v3), configurable via `.env` (`TMDB_BASE_URL`)
  static String get tmdbBaseUrl => EnvConfig.get(
        'TMDB_BASE_URL',
        fallback: 'https://api.themoviedb.org/3',
      );

  // TVmaze Base URL (free public TV Shows API), configurable via `.env` (`TVMAZE_BASE_URL`)
  static String get tvmazeBaseUrl => EnvConfig.get(
        'TVMAZE_BASE_URL',
        fallback: 'https://api.tvmaze.com',
      );

  // TMDB Image CDN base URLs
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String imageW200 = '$tmdbImageBaseUrl/w200';
  static const String imageW300 = '$tmdbImageBaseUrl/w300';
  static const String imageW500 = '$tmdbImageBaseUrl/w500';
  static const String imageW780 = '$tmdbImageBaseUrl/w780';
  static const String imageOriginal = '$tmdbImageBaseUrl/original';

  // Helper method to resolve full poster URL
  static String posterUrl(String? path, {String quality = imageW500}) {
    if (path == null || path.isEmpty) return '';
    return path.startsWith('http') ? path : '$quality$path';
  }

  // Helper method to resolve full backdrop URL
  static String backdropUrl(String? path, {String quality = imageOriginal}) {
    if (path == null || path.isEmpty) return '';
    return path.startsWith('http') ? path : '$quality$path';
  }

  // Helper method to resolve profile picture URL
  static String profileUrl(String? path, {String quality = imageW300}) {
    if (path == null || path.isEmpty) return '';
    return path.startsWith('http') ? path : '$quality$path';
  }
}

