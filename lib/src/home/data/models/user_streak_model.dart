import 'dart:convert';

import '../../domain/entities/user_streak.dart';

class UserStreakModel extends UserStreak {
  const UserStreakModel({
    required super.userId,
    required super.currentStreak,
    required super.longestStreak,
    required super.completedDates,
    required super.lastReadDate,
    super.firstAppUseDate,
  });

  factory UserStreakModel.fromMap(Map<String, dynamic> map) {
    return UserStreakModel(
      userId: map['userId'] as String,
      currentStreak: map['currentStreak'] as int,
      longestStreak: map['longestStreak'] as int,
      completedDates: (map['completedDates'] as List)
          .map((date) => DateTime.parse(date as String))
          .toList(),
      lastReadDate: map['lastReadDate'] != null
          ? DateTime.parse(map['lastReadDate'] as String)
          : null,
      firstAppUseDate: map['firstAppUseDate'] != null
          ? DateTime.parse(map['firstAppUseDate'] as String)
          : null,
    );
  }

  factory UserStreakModel.fromJson(String source) =>
      UserStreakModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      'lastReadDate': lastReadDate?.toIso8601String(),
      'firstAppUseDate': firstAppUseDate?.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  UserStreakModel copyWith({
    String? userId,
    int? currentStreak,
    int? longestStreak,
    List<DateTime>? completedDates,
    DateTime? lastReadDate,
    DateTime? firstAppUseDate,
  }) {
    return UserStreakModel(
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completedDates: completedDates ?? this.completedDates,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      firstAppUseDate: firstAppUseDate ?? this.firstAppUseDate,
    );
  }
}