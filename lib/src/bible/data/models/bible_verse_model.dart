import '../../domain/entities/bible_verse.dart';

class BibleVerseModel extends BibleVerse {
  const BibleVerseModel({
    required super.book,
    required super.chapter,
    required super.verse,
    required super.text,
  });

  factory BibleVerseModel.fromMap(Map<String, dynamic> map) {
    return BibleVerseModel(
      book: map['book'] as String,
      chapter: map['chapter'] as int,
      verse: map['verse'] as int,
      text: map['text'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
    };
  }

  factory BibleVerseModel.fromEntity(BibleVerse verse) {
    return BibleVerseModel(
      book: verse.book,
      chapter: verse.chapter,
      verse: verse.verse,
      text: verse.text,
    );
  }
}