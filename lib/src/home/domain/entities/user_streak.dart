import 'package:equatable/equatable.dart';

class UserStreak extends Equatable {
  const UserStreak({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    required this.completedDates,
    required this.lastReadDate,
    this.firstAppUseDate,
  });

  final String userId;
  final int currentStreak;
  final int longestStreak;
  final List<DateTime> completedDates;
  final DateTime? lastReadDate;
  final DateTime? firstAppUseDate; // When the user first started using the app

  @override
  List<Object?> get props => [
        userId,
        currentStreak,
        longestStreak,
        completedDates,
        lastReadDate,
        firstAppUseDate,
      ];
}