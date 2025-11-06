import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class SaveNote extends UseCaseWithParams<void, Note> {
  const SaveNote(this._repository);

  final NotesRepository _repository;

  @override
  ResultFuture<void> call(Note params) => _repository.saveNote(params);
}