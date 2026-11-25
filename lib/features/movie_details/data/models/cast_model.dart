import '../../domain/entities/movie_details.dart';

class CastModel extends CastMember {
  const CastModel({
    required super.id,
    required super.name,
    required super.role,
    required super.profilePath,
    super.isDirector,
  });

  factory CastModel.fromCastJson(Map<String, dynamic> json) {
    final character = (json['character'] ?? '').toString().trim();
    return CastModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      role: character.isNotEmpty ? character : 'Cast',
      profilePath: (json['profile_path'] ?? '').toString(),
      isDirector: false,
    );
  }

  factory CastModel.fromCrewJson(Map<String, dynamic> json) {
    final job = (json['job'] ?? 'Crew').toString().trim();
    return CastModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      role: job.isNotEmpty ? job : 'Crew',
      profilePath: (json['profile_path'] ?? '').toString(),
      isDirector: job.toLowerCase() == 'director',
    );
  }

  factory CastModel.fromTvMazeCastJson(Map<String, dynamic> json) {
    final person = json['person'] as Map<String, dynamic>? ?? const {};
    final character = json['character'] as Map<String, dynamic>? ?? const {};
    final personImg = person['image'] as Map<String, dynamic>? ?? const {};
    final charImg = character['image'] as Map<String, dynamic>? ?? const {};
    final imageUrl =
        (personImg['medium'] ?? charImg['medium'] ?? '').toString();
    final charName = (character['name'] ?? 'Cast').toString().trim();

    return CastModel(
      id: (person['id'] as num?)?.toInt() ?? 0,
      name: (person['name'] ?? '').toString(),
      role: charName.isNotEmpty ? charName : 'Cast',
      profilePath: imageUrl,
      isDirector: false,
    );
  }

  factory CastModel.fromTvMazeCrewJson(Map<String, dynamic> json) {
    final person = json['person'] as Map<String, dynamic>? ?? const {};
    final personImg = person['image'] as Map<String, dynamic>? ?? const {};
    final type = (json['type'] ?? 'Crew').toString().trim();
    final isCreator = type.toLowerCase().contains('creator');

    return CastModel(
      id: (person['id'] as num?)?.toInt() ?? 0,
      name: (person['name'] ?? '').toString(),
      role: type.isNotEmpty ? type : 'Crew',
      profilePath: (personImg['medium'] ?? '').toString(),
      isDirector: isCreator,
    );
  }
}

