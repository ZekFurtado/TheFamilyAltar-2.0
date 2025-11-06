import 'package:equatable/equatable.dart';

class Note extends Equatable {
  const Note({
    required this.id,
    required this.userId,
    required this.readingId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.highlightedText,
    this.textPosition,
    this.highlightColor,
  });

  final String id;
  final String userId;
  final String readingId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? highlightedText;
  final int? textPosition;
  final String? highlightColor;

  Note copyWith({
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
    return Note(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        readingId,
        content,
        createdAt,
        updatedAt,
        highlightedText,
        textPosition,
        highlightColor,
      ];
}