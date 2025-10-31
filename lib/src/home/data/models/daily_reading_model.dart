import 'dart:convert';

import '../../domain/entities/daily_reading.dart';

class DailyReadingModel extends DailyReading {
  const DailyReadingModel({
    required super.id,
    required super.date,
    required super.title,
    required super.scripture,
    required super.scriptureText,
    required super.sermonContent,
    required super.scripturesForDay,
    required super.sermonReference,
  });

  factory DailyReadingModel.fromMap(Map<String, dynamic> map) {
    return DailyReadingModel(
      id: map['id'] as String,
      date: map['date'] as String,
      // Keep as string for human-readable dates
      title: map['title'] as String,
      scripture: map['scripture'] as String,
      scriptureText: map['scriptureText'] as String,
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
      'date': date, // Keep as string
      'title': title,
      'scripture': scripture,
      'scriptureText': scriptureText,
      'sermonContent': sermonContent,
      'scripturesForDay': scripturesForDay,
      'sermonReference': sermonReference,
    };
  }

  String toJson() => json.encode(toMap());

  DailyReadingModel copyWith({
    String? id,
    String? date,
    String? title,
    String? scripture,
    String? scriptureText,
    String? sermonContent,
    List<String>? scripturesForDay,
    String? sermonReference,
  }) {
    return DailyReadingModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      scripture: scripture ?? this.scripture,
      scriptureText: scriptureText ?? this.scriptureText,
      sermonContent: sermonContent ?? this.sermonContent,
      scripturesForDay: scripturesForDay ?? this.scripturesForDay,
      sermonReference: sermonReference ?? this.sermonReference,
    );
  }
}
