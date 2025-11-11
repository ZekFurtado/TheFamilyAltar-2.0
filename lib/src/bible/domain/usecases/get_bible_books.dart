import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/bible_book.dart';
import '../repositories/bible_repository.dart';

class GetBibleBooks extends UseCaseWithParams<List<BibleBook>, GetBibleBooksParams> {
  const GetBibleBooks(this._repository);

  final BibleRepository _repository;

  @override
  ResultFuture<List<BibleBook>> call(GetBibleBooksParams params) async {
    return _repository.getBooks(params.versionId);
  }
}

class GetBibleBooksParams extends Equatable {
  const GetBibleBooksParams({required this.versionId});

  final String versionId;

  @override
  List<Object?> get props => [versionId];
}