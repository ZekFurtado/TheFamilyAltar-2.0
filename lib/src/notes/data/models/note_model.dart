import 'dart:convert';

import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.userId,
    required super.readingId,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
    super.highlightedText,
    super.textPosition,
    super.highlightColor,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      readingId: map['readingId'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      highlightedText: map['highlightedText'] as String?,
      textPosition: map['textPosition'] as int?,
      highlightColor: map['highlightColor'] as String?,
    );
  }

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      userId: note.userId,
      readingId: note.readingId,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      highlightedText: note.highlightedText,
      textPosition: note.textPosition,
      highlightColor: note.highlightColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'readingId': readingId,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'highlightedText': highlightedText,
      'textPosition': textPosition,
      'highlightColor': highlightColor,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  NoteModel copyWith({
    String? id,
    String? userId,
    String? readingId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? highlightedText,
    int? textPosition,
    String? highlightColor,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      readingId: readingId ?? this.readingId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      highlightedText: highlightedText ?? this.highlightedText,
      textPosition: textPosition ?? this.textPosition,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }
}