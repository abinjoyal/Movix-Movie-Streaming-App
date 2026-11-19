/// Download status state enumeration.
enum DownloadStatus {
  downloading,
  downloaded,
  paused,
  failed,
}

/// Domain entity representing a movie downloaded or currently downloading for offline viewing.
class DownloadedMovie {
  final String id;
  final int tmdbId;
  final String title;
  final String backdropPath;
  final String posterPath;
  final String duration;
  final String fileSize;
  final DownloadStatus status;
  final double progress; // 0.0 to 1.0
  final String? localFilePath;
  final DateTime downloadedAt;

  const DownloadedMovie({
    required this.id,
    required this.tmdbId,
    required this.title,
    required this.backdropPath,
    required this.posterPath,
    required this.duration,
    required this.fileSize,
    required this.status,
    this.progress = 1.0,
    this.localFilePath,
    required this.downloadedAt,
  });

  String get fullBackdropUrl {
    if (backdropPath.trim().isEmpty) return '';
    if (backdropPath.startsWith('http')) return backdropPath;
    final path = backdropPath.startsWith('/') ? backdropPath : '/$backdropPath';
    return 'https://image.tmdb.org/t/p/w780$path';
  }

  String get fullPosterUrl {
    if (posterPath.trim().isEmpty) return '';
    if (posterPath.startsWith('http')) return posterPath;
    final path = posterPath.startsWith('/') ? posterPath : '/$posterPath';
    return 'https://image.tmdb.org/t/p/w500$path';
  }

  DownloadedMovie copyWith({
    String? id,
    int? tmdbId,
    String? title,
    String? backdropPath,
    String? posterPath,
    String? duration,
    String? fileSize,
    DownloadStatus? status,
    double? progress,
    String? localFilePath,
    DateTime? downloadedAt,
  }) {
    return DownloadedMovie(
      id: id ?? this.id,
      tmdbId: tmdbId ?? this.tmdbId,
      title: title ?? this.title,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      duration: duration ?? this.duration,
      fileSize: fileSize ?? this.fileSize,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      localFilePath: localFilePath ?? this.localFilePath,
      downloadedAt: downloadedAt ?? this.downloadedAt,
    );
  }
}

