import 'package:equatable/equatable.dart';

class UserStreak extends Equatable {
  const UserStreak({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    required this.completedDates,
    required this.lastReadDate,
  });

  final String userId;
  final int currentStreak;
  final int longestStreak;
  final List<DateTime> completedDates;
  final DateTime? lastReadDate;

  @override
  List<Object?> get props => [
        userId,
        currentStreak,
        longestStreak,
        completedDates,
        lastReadDate,
      ];
}