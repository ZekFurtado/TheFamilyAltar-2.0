import 'package:equatable/equatable.dart';

import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import '../entities/user_streak.dart';
import '../repositories/home_repository.dart';

class GetUserStreak extends UseCaseWithParams<UserStreak, GetUserStreakParams> {
  const GetUserStreak(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<UserStreak> call(GetUserStreakParams params) =>
      _repository.getUserStreak(params.userId);
}

class GetUserStreakParams extends Equatable {
  const GetUserStreakParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}