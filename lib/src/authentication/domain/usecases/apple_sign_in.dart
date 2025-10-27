import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AppleSignIn extends UseCaseWithoutParams<LocalUser> {
  final AuthRepository repository;

  AppleSignIn(this.repository);

  @override
  ResultFuture<LocalUser> call() {
    return repository.appleSignIn();
  }
}