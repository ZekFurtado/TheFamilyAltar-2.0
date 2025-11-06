import 'dart:convert';

import '../../domain/entities/highlight.dart';

class HighlightModel extends Highlight {
  const HighlightModel({
    required super.id,
    required super.userId,
    required super.readingId,
    required super.selectedText,
    required super.startPosition,
    required super.endPosition,
    required super.color,
    required super.createdAt,
    super.note,
  });

  factory HighlightModel.fromMap(Map<String, dynamic> map) {
    return HighlightModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      readingId: map['readingId'] as String,
      selectedText: map['selectedText'] as String,
      startPosition: map['startPosition'] as int,
      endPosition: map['endPosition'] as int,
      color: map['color'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      note: map['note'] as String?,
    );
  }

  factory HighlightModel.fromJson(String source) =>
      HighlightModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory HighlightModel.fromEntity(Highlight highlight) {
    return HighlightModel(
      id: highlight.id,
      userId: highlight.userId,
      readingId: highlight.readingId,
      selectedText: highlight.selectedText,
      startPosition: highlight.startPosition,
      endPosition: highlight.endPosition,
      color: highlight.color,
      createdAt: highlight.createdAt,
      note: highlight.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'readingId': readingId,
      'selectedText': selectedText,
      'startPosition': startPosition,
      'endPosition': endPosition,
      'color': color,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'note': note,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  HighlightModel copyWith({
    String? id,
    String? userId,
    String? readingId,
    String? selectedText,
    int? startPosition,
    int? endPosition,
    String? color,
    DateTime? createdAt,
    String? note,
  }) {
    return HighlightModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      readingId: readingId ?? this.readingId,
      selectedText: selectedText ?? this.selectedText,
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }
}