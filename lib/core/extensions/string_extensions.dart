import '../constants/api_endpoints.dart';

/// Extension methods on [String].
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Resolves this relative TMDB poster path into a full image CDN URL.
  String toPosterUrl({String quality = ApiEndpoints.imageW500}) {
    return ApiEndpoints.posterUrl(this, quality: quality);
  }

  /// Resolves this relative TMDB backdrop path into a full image CDN URL.
  String toBackdropUrl({String quality = ApiEndpoints.imageOriginal}) {
    return ApiEndpoints.backdropUrl(this, quality: quality);
  }
}

/// Extension methods on nullable [String].
extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}

