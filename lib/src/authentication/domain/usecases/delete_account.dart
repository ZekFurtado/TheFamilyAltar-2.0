import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repositories/auth_repository.dart';

class DeleteAccount extends UseCaseWithoutParams<void> {
  final AuthRepository _repository;

  DeleteAccount(this._repository);

  @override
  ResultFuture<void> call() => _repository.deleteAccount();
}