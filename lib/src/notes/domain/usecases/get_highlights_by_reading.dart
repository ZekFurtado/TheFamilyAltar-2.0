import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/highlight.dart';
import '../repositories/notes_repository.dart';

class GetHighlightsByReading extends UseCaseWithParams<List<Highlight>, GetHighlightsByReadingParams> {
  const GetHighlightsByReading(this._repository);

  final NotesRepository _repository;

  @override
  ResultFuture<List<Highlight>> call(GetHighlightsByReadingParams params) =>
      _repository.getHighlightsByReading(params.userId, params.readingId);
}

class GetHighlightsByReadingParams extends Equatable {
  const GetHighlightsByReadingParams({
    required this.userId,
    required this.readingId,
  });

  final String userId;
  final String readingId;

  @override
  List<Object> get props => [userId, readingId];
}