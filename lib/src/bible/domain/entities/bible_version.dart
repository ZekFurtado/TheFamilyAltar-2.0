import 'package:equatable/equatable.dart';

enum BibleVersionType { kjv, nkjv, hindi }

class BibleVersion extends Equatable {
  const BibleVersion({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.type,
    required this.language,
    required this.isDownloaded,
  });

  final String id;
  final String name;
  final String abbreviation;
  final BibleVersionType type;
  final String language;
  final bool isDownloaded;

  BibleVersion copyWith({
    String? id,
    String? name,
    String? abbreviation,
    BibleVersionType? type,
    String? language,
    bool? isDownloaded,
  }) {
    return BibleVersion(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      type: type ?? this.type,
      language: language ?? this.language,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        abbreviation,
        type,
        language,
        isDownloaded,
      ];
}