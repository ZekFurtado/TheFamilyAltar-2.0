import 'package:equatable/equatable.dart';

class DailyReading extends Equatable {
  const DailyReading({
    required this.id,
    required this.date,
    required this.title,
    required this.scripture,
    required this.sermonContent,
    required this.scripturesForDay,
    required this.sermonReference,
  });

  final String id;
  final String date; // Human-readable date like "January 1"
  final String title;
  final String scripture;
  final String sermonContent;
  final List<String> scripturesForDay;
  final String sermonReference;

  @override
  List<Object?> get props => [
        id,
        date,
        title,
        scripture,
        sermonContent,
        scripturesForDay,
        sermonReference,
      ];
}