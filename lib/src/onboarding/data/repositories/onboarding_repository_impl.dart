import 'package:dartz/dartz.dart';
import 'package:thefamilyaltar/core/errors/exceptions.dart';
import 'package:thefamilyaltar/core/errors/failures.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import 'package:thefamilyaltar/src/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:thefamilyaltar/src/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  ResultVoid cacheFirstTimer() async {
    try {
      await _localDataSource.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    try {
      final result = await _localDataSource.checkIfUserIsFirstTimer();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}