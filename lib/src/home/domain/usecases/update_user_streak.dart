import 'package:equatable/equatable.dart';

import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import '../repositories/home_repository.dart';

class UpdateUserStreak extends UseCaseWithParams<void, UpdateUserStreakParams> {
  const UpdateUserStreak(this._repository);

  final HomeRepository _repository;

  @override
  ResultVoid call(UpdateUserStreakParams params) =>
      _repository.updateUserStreak(params.userId, params.readDate);
}

class UpdateUserStreakParams extends Equatable {
  const UpdateUserStreakParams({
    required this.userId,
    required this.readDate,
  });

  final String userId;
  final DateTime readDate;

  @override
  List<Object?> get props => [userId, readDate];
}