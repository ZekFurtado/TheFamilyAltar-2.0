import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/highlight.dart';
import '../repositories/notes_repository.dart';

class SaveHighlight extends UseCaseWithParams<void, Highlight> {
  const SaveHighlight(this._repository);

  final NotesRepository _repository;

  @override
  ResultFuture<void> call(Highlight params) => _repository.saveHighlight(params);
}