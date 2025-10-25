import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import 'package:thefamilyaltar/src/authentication/domain/repositories/auth_repository.dart';

class GetUserSession extends UseCaseWithoutParams {
  final AuthRepository repository;

  GetUserSession(this.repository);

  @override
  ResultFuture call() {
    return repository.getUserSession();
  }
}
