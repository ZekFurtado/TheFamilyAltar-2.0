part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodaysReading extends HomeEvent {
  const LoadTodaysReading();
}

class LoadReadingByDate extends HomeEvent {
  const LoadReadingByDate({required this.date});

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class LoadUserStreak extends HomeEvent {
  const LoadUserStreak({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MarkReadingComplete extends HomeEvent {
  const MarkReadingComplete({
    required this.userId,
    required this.readDate,
  });

  final String userId;
  final DateTime readDate;

  @override
  List<Object?> get props => [userId, readDate];
}