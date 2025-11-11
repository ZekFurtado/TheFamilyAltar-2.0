import '../../domain/entities/bible_chapter.dart';
import '../../domain/entities/bible_verse.dart';
import 'bible_verse_model.dart';

class BibleChapterModel extends BibleChapter {
  const BibleChapterModel({
    required super.book,
    required super.chapterNumber,
    required super.verses,
  });

  factory BibleChapterModel.fromMap(Map<String, dynamic> map) {
    return BibleChapterModel(
      book: map['book'] as String,
      chapterNumber: map['chapterNumber'] as int,
      verses: (map['verses'] as List<dynamic>)
          .map((verse) => BibleVerseModel.fromMap(verse as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'chapterNumber': chapterNumber,
      'verses': verses.map((verse) => BibleVerseModel.fromEntity(verse).toMap()).toList(),
    };
  }

  factory BibleChapterModel.fromEntity(BibleChapter chapter) {
    return BibleChapterModel(
      book: chapter.book,
      chapterNumber: chapter.chapterNumber,
      verses: chapter.verses,
    );
  }
}