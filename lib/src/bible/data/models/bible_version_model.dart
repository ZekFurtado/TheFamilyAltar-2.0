import '../../domain/entities/bible_version.dart';

class BibleVersionModel extends BibleVersion {
  const BibleVersionModel({
    required super.id,
    required super.name,
    required super.abbreviation,
    required super.type,
    required super.language,
    required super.isDownloaded,
  });

  factory BibleVersionModel.fromMap(Map<String, dynamic> map) {
    return BibleVersionModel(
      id: map['id'] as String,
      name: map['name'] as String,
      abbreviation: map['abbreviation'] as String,
      type: BibleVersionType.values.firstWhere(
        (type) => type.name == map['type'],
        orElse: () => BibleVersionType.kjv,
      ),
      language: map['language'] as String,
      isDownloaded: map['isDownloaded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'type': type.name,
      'language': language,
      'isDownloaded': isDownloaded,
    };
  }

  factory BibleVersionModel.fromEntity(BibleVersion version) {
    return BibleVersionModel(
      id: version.id,
      name: version.name,
      abbreviation: version.abbreviation,
      type: version.type,
      language: version.language,
      isDownloaded: version.isDownloaded,
    );
  }

  @override
  BibleVersionModel copyWith({
    String? id,
    String? name,
    String? abbreviation,
    BibleVersionType? type,
    String? language,
    bool? isDownloaded,
  }) {
    return BibleVersionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      type: type ?? this.type,
      language: language ?? this.language,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}