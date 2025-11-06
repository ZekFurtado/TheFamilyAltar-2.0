import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/notes_repository.dart';

class DeleteHighlight extends UseCaseWithParams<void, String> {
  const DeleteHighlight(this._repository);

  final NotesRepository _repository;

  @override
  ResultFuture<void> call(String params) => _repository.deleteHighlight(params);
}