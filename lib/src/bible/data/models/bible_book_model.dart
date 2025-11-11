import '../../domain/entities/bible_book.dart';

class BibleBookModel extends BibleBook {
  const BibleBookModel({
    required super.id,
    required super.name,
    required super.shortName,
    required super.chapterCount,
    required super.testament,
    required super.order,
  });

  factory BibleBookModel.fromMap(Map<String, dynamic> map) {
    return BibleBookModel(
      id: map['id'] as int,
      name: map['name'] as String,
      shortName: map['shortName'] as String,
      chapterCount: map['chapterCount'] as int,
      testament: map['testament'] == 'old' ? Testament.oldTestament : Testament.newTestament,
      order: map['order'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'chapterCount': chapterCount,
      'testament': testament == Testament.oldTestament ? 'old' : 'new',
      'order': order,
    };
  }

  factory BibleBookModel.fromEntity(BibleBook book) {
    return BibleBookModel(
      id: book.id,
      name: book.name,
      shortName: book.shortName,
      chapterCount: book.chapterCount,
      testament: book.testament,
      order: book.order,
    );
  }
}