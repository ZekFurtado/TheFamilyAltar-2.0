import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/bible_chapter.dart';
import '../repositories/bible_repository.dart';

class GetBibleChapter extends UseCaseWithParams<BibleChapter, GetBibleChapterParams> {
  const GetBibleChapter(this._repository);

  final BibleRepository _repository;

  @override
  ResultFuture<BibleChapter> call(GetBibleChapterParams params) async {
    return _repository.getChapter(
      versionId: params.versionId,
      book: params.book,
      chapter: params.chapter,
    );
  }
}

class GetBibleChapterParams extends Equatable {
  const GetBibleChapterParams({
    required this.versionId,
    required this.book,
    required this.chapter,
  });

  final String versionId;
  final String book;
  final int chapter;

  @override
  List<Object?> get props => [versionId, book, chapter];
}