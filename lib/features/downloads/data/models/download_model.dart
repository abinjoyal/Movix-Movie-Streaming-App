import '../../domain/entities/downloaded_movie.dart';

class DownloadModel extends DownloadedMovie {
  const DownloadModel({
    required super.id,
    required super.tmdbId,
    required super.title,
    required super.backdropPath,
    required super.posterPath,
    required super.duration,
    required super.fileSize,
    required super.status,
    super.progress,
    super.localFilePath,
    required super.downloadedAt,
  });

  factory DownloadModel.fromJson(Map<String, dynamic> json) {
    return DownloadModel(
      id: json['id'] as String,
      tmdbId: json['tmdb_id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      backdropPath: json['backdrop_path'] as String? ?? '',
      posterPath: json['poster_path'] as String? ?? '',
      duration: json['duration'] as String? ?? '1h 45m',
      fileSize: json['file_size'] as String? ?? '1.5 GB',
      status: DownloadStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DownloadStatus.downloaded,
      ),
      progress: (json['progress'] as num?)?.toDouble() ?? 1.0,
      localFilePath: json['local_file_path'] as String?,
      downloadedAt: json['downloaded_at'] != null
          ? DateTime.parse(json['downloaded_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tmdb_id': tmdbId,
      'title': title,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
      'duration': duration,
      'file_size': fileSize,
      'status': status.name,
      'progress': progress,
      'local_file_path': localFilePath,
      'downloaded_at': downloadedAt.toIso8601String(),
    };
  }

  factory DownloadModel.fromEntity(DownloadedMovie entity) {
    return DownloadModel(
      id: entity.id,
      tmdbId: entity.tmdbId,
      title: entity.title,
      backdropPath: entity.backdropPath,
      posterPath: entity.posterPath,
      duration: entity.duration,
      fileSize: entity.fileSize,
      status: entity.status,
      progress: entity.progress,
      localFilePath: entity.localFilePath,
      downloadedAt: entity.downloadedAt,
    );
  }
}

