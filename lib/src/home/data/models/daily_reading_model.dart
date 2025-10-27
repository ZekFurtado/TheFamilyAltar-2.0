import 'dart:convert';

import '../../domain/entities/daily_reading.dart';

class DailyReadingModel extends DailyReading {
  const DailyReadingModel({
    required super.id,
    required super.date,
    required super.title,
    required super.scripture,
    required super.sermonContent,
    required super.scripturesForDay,
    required super.sermonReference,
  });

  factory DailyReadingModel.fromMap(Map<String, dynamic> map) {
    return DailyReadingModel(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      title: map['title'] as String,
      scripture: map['scripture'] as String,
      sermonContent: map['sermonContent'] as String,
      scripturesForDay: List<String>.from(map['scripturesForDay'] as List),
      sermonReference: map['sermonReference'] as String,
    );
  }

  factory DailyReadingModel.fromJson(String source) =>
      DailyReadingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'scripture': scripture,
      'sermonContent': sermonContent,
      'scripturesForDay': scripturesForDay,
      'sermonReference': sermonReference,
    };
  }

  String toJson() => json.encode(toMap());

  DailyReadingModel copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? scripture,
    String? sermonContent,
    List<String>? scripturesForDay,
    String? sermonReference,
  }) {
    return DailyReadingModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      scripture: scripture ?? this.scripture,
      sermonContent: sermonContent ?? this.sermonContent,
      scripturesForDay: scripturesForDay ?? this.scripturesForDay,
      sermonReference: sermonReference ?? this.sermonReference,
    );
  }
}