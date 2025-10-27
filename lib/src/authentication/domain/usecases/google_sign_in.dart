import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GoogleSignIn extends UseCaseWithoutParams<LocalUser> {
  final AuthRepository repository;

  GoogleSignIn(this.repository);

  @override
  ResultFuture<LocalUser> call() {
    return repository.googleSignIn();
  }
}