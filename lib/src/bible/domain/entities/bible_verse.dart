import 'package:equatable/equatable.dart';

class BibleVerse extends Equatable {
  const BibleVerse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  final String book;
  final int chapter;
  final int verse;
  final String text;

  String get reference => '$book $chapter:$verse';

  @override
  List<Object?> get props => [
        book,
        chapter,
        verse,
        text,
      ];
}