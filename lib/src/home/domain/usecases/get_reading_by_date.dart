import 'package:equatable/equatable.dart';

import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import '../entities/daily_reading.dart';
import '../repositories/home_repository.dart';

class GetReadingByDate extends UseCaseWithParams<DailyReading, GetReadingByDateParams> {
  const GetReadingByDate(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<DailyReading> call(GetReadingByDateParams params) =>
      _repository.getReadingByDate(params.date);
}

class GetReadingByDateParams extends Equatable {
  const GetReadingByDateParams({required this.date});

  final DateTime date;

  @override
  List<Object?> get props => [date];
}