import 'package:thefamilyaltar/core/utils/typedef.dart';
import '../entities/daily_reading.dart';
import '../entities/user_streak.dart';

abstract class HomeRepository {
  ResultFuture<DailyReading> getTodaysReading();
  ResultFuture<DailyReading> getReadingByDate(DateTime date);
  ResultFuture<UserStreak> getUserStreak(String userId);
  ResultVoid updateUserStreak(String userId, DateTime readDate);
  ResultFuture<List<DailyReading>> getRecentReadings(String userId);
}