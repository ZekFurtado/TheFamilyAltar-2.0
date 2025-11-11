import 'package:equatable/equatable.dart';

enum Testament { oldTestament, newTestament }

class BibleBook extends Equatable {
  const BibleBook({
    required this.id,
    required this.name,
    required this.shortName,
    required this.chapterCount,
    required this.testament,
    required this.order,
  });

  final int id;
  final String name;
  final String shortName;
  final int chapterCount;
  final Testament testament;
  final int order;

  @override
  List<Object?> get props => [
        id,
        name,
        shortName,
        chapterCount,
        testament,
        order,
      ];
}