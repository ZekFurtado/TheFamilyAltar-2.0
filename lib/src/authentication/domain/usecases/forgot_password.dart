import 'package:equatable/equatable.dart';
import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';

import '../repositories/auth_repository.dart';

class ForgotPassword extends UseCaseWithParams<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  @override
  ResultFuture<void> call(ForgotPasswordParams params) {
    return repository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.email});

  const ForgotPasswordParams.empty() : this(email: 'empty.email');

  final String email;

  @override
  List<Object?> get props => [email];
}