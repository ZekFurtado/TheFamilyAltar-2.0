import 'package:thefamilyaltar/core/utils/typedef.dart';

abstract class OnboardingRepository {
  const OnboardingRepository();

  ResultVoid cacheFirstTimer();
  ResultFuture<bool> checkIfUserIsFirstTimer();
}