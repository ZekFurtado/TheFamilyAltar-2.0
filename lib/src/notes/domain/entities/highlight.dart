import 'package:equatable/equatable.dart';

class Highlight extends Equatable {
  const Highlight({
    required this.id,
    required this.userId,
    required this.readingId,
    required this.selectedText,
    required this.startPosition,
    required this.endPosition,
    required this.color,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String userId;
  final String readingId;
  final String selectedText;
  final int startPosition;
  final int endPosition;
  final String color;
  final DateTime createdAt;
  final String? note;

  Highlight copyWith({
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
    return Highlight(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        readingId,
        selectedText,
        startPosition,
        endPosition,
        color,
        createdAt,
        note,
      ];
}