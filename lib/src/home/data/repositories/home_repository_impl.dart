import 'package:dartz/dartz.dart';

import 'package:thefamilyaltar/core/errors/exceptions.dart';
import 'package:thefamilyaltar/core/errors/failures.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import '../../domain/entities/daily_reading.dart';
import '../../domain/entities/user_streak.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required this.remoteDataSource});

  final HomeRemoteDataSource remoteDataSource;

  @override
  ResultFuture<DailyReading> getTodaysReading() async {
    try {
      final result = await remoteDataSource.getTodaysReading();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<DailyReading> getReadingByDate(DateTime date) async {
    try {
      final result = await remoteDataSource.getReadingByDate(date);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserStreak> getUserStreak(String userId) async {
    try {
      final result = await remoteDataSource.getUserStreak(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid updateUserStreak(String userId, DateTime readDate) async {
    try {
      await remoteDataSource.updateUserStreak(userId, readDate);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<DailyReading>> getRecentReadings(String userId) async {
    try {
      final result = await remoteDataSource.getRecentReadings(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}