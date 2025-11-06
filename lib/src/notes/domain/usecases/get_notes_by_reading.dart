import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetNotesByReading extends UseCaseWithParams<List<Note>, GetNotesByReadingParams> {
  const GetNotesByReading(this._repository);

  final NotesRepository _repository;

  @override
  ResultFuture<List<Note>> call(GetNotesByReadingParams params) =>
      _repository.getNotesByReading(params.userId, params.readingId);
}

class GetNotesByReadingParams extends Equatable {
  const GetNotesByReadingParams({
    required this.userId,
    required this.readingId,
  });

  final String userId;
  final String readingId;

  @override
  List<Object> get props => [userId, readingId];
}