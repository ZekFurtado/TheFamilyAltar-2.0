import 'package:thefamilyaltar/core/usecases/usecase.dart';
import 'package:thefamilyaltar/core/utils/typedef.dart';
import '../entities/daily_reading.dart';
import '../repositories/home_repository.dart';

class GetTodaysReading extends UseCaseWithoutParams<DailyReading> {
  const GetTodaysReading(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<DailyReading> call() => _repository.getTodaysReading();
}