import '../../domain/entities/movie_details.dart';

class TrailerModel extends MovieTrailer {
  const TrailerModel({
    required super.id,
    required super.key,
    required super.name,
    required super.site,
    required super.type,
    super.official,
    super.publishedAt,
    super.durationLabel,
    super.authorizedVideoUrl,
    super.customThumbnailUrl,
  });

  factory TrailerModel.fromJson(Map<String, dynamic> json) {
    return TrailerModel(
      id: (json['id'] ?? '').toString(),
      key: (json['key'] ?? '').toString(),
      name: (json['name'] ?? 'Trailer').toString(),
      site: (json['site'] ?? 'YouTube').toString(),
      type: (json['type'] ?? 'Trailer').toString(),
      official: json['official'] == true,
      publishedAt: json['published_at']?.toString(),
      durationLabel: json['duration']?.toString(),
      authorizedVideoUrl: json['authorized_video_url']?.toString(),
    );
  }

  factory TrailerModel.fromTvMazeEpisodeJson(Map<String, dynamic> json) {
    final season = (json['season'] as num?)?.toInt() ?? 1;
    final number = (json['number'] as num?)?.toInt() ?? 1;
    final epName = (json['name'] ?? 'Episode').toString();
    final runtime = (json['runtime'] as num?)?.toInt();
    final image = json['image'] as Map<String, dynamic>? ?? const {};
    final thumb = (image['medium'] ?? image['original'] ?? '').toString();

    return TrailerModel(
      id: (json['id'] ?? '').toString(),
      key: (json['id'] ?? '').toString(),
      name: 'S$season E$number • $epName',
      site: 'TVmaze',
      type: 'Episode',
      official: true,
      publishedAt: json['airdate']?.toString(),
      durationLabel: runtime != null ? '${runtime}m' : null,
      authorizedVideoUrl: json['url']?.toString(),
      customThumbnailUrl: thumb,
    );
  }
}

