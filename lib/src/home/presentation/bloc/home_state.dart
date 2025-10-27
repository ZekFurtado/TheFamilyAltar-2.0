part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class TodaysReadingLoaded extends HomeState {
  const TodaysReadingLoaded({required this.reading});

  final DailyReading reading;

  @override
  List<Object?> get props => [reading];
}

class ReadingByDateLoaded extends HomeState {
  const ReadingByDateLoaded({required this.reading});

  final DailyReading reading;

  @override
  List<Object?> get props => [reading];
}

class UserStreakLoaded extends HomeState {
  const UserStreakLoaded({required this.streak});

  final UserStreak streak;

  @override
  List<Object?> get props => [streak];
}

class ReadingMarkedComplete extends HomeState {
  const ReadingMarkedComplete();
}

class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}