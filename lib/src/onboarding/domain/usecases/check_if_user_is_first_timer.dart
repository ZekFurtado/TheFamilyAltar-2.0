import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import 'package:thefamilyaltar/src/onboarding/domain/repositories/onboarding_repository.dart';

class CheckIfUserIsFirstTimer extends UseCaseWithoutParams<bool> {
  const CheckIfUserIsFirstTimer(this._repository);

  final OnboardingRepository _repository;

  @override
  ResultFuture<bool> call() => _repository.checkIfUserIsFirstTimer();
}