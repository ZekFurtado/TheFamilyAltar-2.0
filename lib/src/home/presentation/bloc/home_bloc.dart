import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/daily_reading.dart';
import '../../domain/entities/user_streak.dart';
import '../../domain/usecases/get_reading_by_date.dart';
import '../../domain/usecases/get_todays_reading.dart';
import '../../domain/usecases/get_user_streak.dart';
import '../../domain/usecases/update_user_streak.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required GetTodaysReading getTodaysReading,
    required GetReadingByDate getReadingByDate,
    required GetUserStreak getUserStreak,
    required UpdateUserStreak updateUserStreak,
  })  : _getTodaysReading = getTodaysReading,
        _getReadingByDate = getReadingByDate,
        _getUserStreak = getUserStreak,
        _updateUserStreak = updateUserStreak,
        super(const HomeInitial()) {
    on<LoadTodaysReading>(_onLoadTodaysReading);
    on<LoadReadingByDate>(_onLoadReadingByDate);
    on<LoadUserStreak>(_onLoadUserStreak);
    on<MarkReadingComplete>(_onMarkReadingComplete);
  }

  final GetTodaysReading _getTodaysReading;
  final GetReadingByDate _getReadingByDate;
  final GetUserStreak _getUserStreak;
  final UpdateUserStreak _updateUserStreak;

  void _onLoadTodaysReading(
    LoadTodaysReading event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await _getTodaysReading();

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (reading) => emit(TodaysReadingLoaded(reading: reading)),
    );
  }

  void _onLoadReadingByDate(
    LoadReadingByDate event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await _getReadingByDate(
      GetReadingByDateParams(date: event.date),
    );

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (reading) => emit(ReadingByDateLoaded(reading: reading, selectedDay: event.date)),
    );
  }

  void _onLoadUserStreak(
    LoadUserStreak event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getUserStreak(
      GetUserStreakParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (streak) => emit(UserStreakLoaded(streak: streak)),
    );
  }

  void _onMarkReadingComplete(
    MarkReadingComplete event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _updateUserStreak(
      UpdateUserStreakParams(
        userId: event.userId,
        readDate: event.readDate,
      ),
    );

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (_) => emit(const ReadingMarkedComplete()),
    );
  }
}