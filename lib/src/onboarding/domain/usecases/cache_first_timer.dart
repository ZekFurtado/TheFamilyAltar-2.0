import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import 'package:thefamilyaltar/src/onboarding/domain/repositories/onboarding_repository.dart';

class CacheFirstTimer extends UseCaseWithoutParams<void> {
  const CacheFirstTimer(this._repository);

  final OnboardingRepository _repository;

  @override
  ResultVoid call() => _repository.cacheFirstTimer();
}