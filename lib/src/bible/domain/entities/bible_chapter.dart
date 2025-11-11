import 'package:equatable/equatable.dart';
import 'bible_verse.dart';

class BibleChapter extends Equatable {
  const BibleChapter({
    required this.book,
    required this.chapterNumber,
    required this.verses,
  });

  final String book;
  final int chapterNumber;
  final List<BibleVerse> verses;

  String get reference => '$book $chapterNumber';

  @override
  List<Object?> get props => [
        book,
        chapterNumber,
        verses,
      ];
}