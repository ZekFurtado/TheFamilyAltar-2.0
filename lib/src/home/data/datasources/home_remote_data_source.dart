import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_reading_model.dart';
import '../models/user_streak_model.dart';

abstract class HomeRemoteDataSource {
  Future<DailyReadingModel> getTodaysReading();
  Future<DailyReadingModel> getReadingByDate(DateTime date);
  Future<UserStreakModel> getUserStreak(String userId);
  Future<void> updateUserStreak(String userId, DateTime readDate);
  Future<List<DailyReadingModel>> getRecentReadings(String userId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<DailyReadingModel> getTodaysReading() async {
    final today = DateTime.now();
    final dateString = '${today.month}-${today.day}';
    
    final doc = await firestore
        .collection('daily_readings')
        .doc(dateString)
        .get();

    if (!doc.exists) {
      throw Exception('No reading found for today');
    }

    return DailyReadingModel.fromMap(doc.data()!);
  }

  @override
  Future<DailyReadingModel> getReadingByDate(DateTime date) async {
    final dateString = '${date.month}-${date.day}';
    
    final doc = await firestore
        .collection('daily_readings')
        .doc(dateString)
        .get();

    if (!doc.exists) {
      throw Exception('No reading found for the selected date');
    }

    return DailyReadingModel.fromMap(doc.data()!);
  }

  @override
  Future<UserStreakModel> getUserStreak(String userId) async {
    final doc = await firestore
        .collection('user_streaks')
        .doc(userId)
        .get();

    if (!doc.exists) {
      return const UserStreakModel(
        userId: '',
        currentStreak: 0,
        longestStreak: 0,
        completedDates: [],
        lastReadDate: null,
      );
    }

    return UserStreakModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updateUserStreak(String userId, DateTime readDate) async {
    final docRef = firestore.collection('user_streaks').doc(userId);
    
    await firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      
      UserStreakModel currentStreak;
      if (doc.exists) {
        currentStreak = UserStreakModel.fromMap(doc.data()!);
      } else {
        currentStreak = UserStreakModel(
          userId: userId,
          currentStreak: 0,
          longestStreak: 0,
          completedDates: [],
          lastReadDate: null,
        );
      }

      final dateOnly = DateTime(readDate.year, readDate.month, readDate.day);
      final completedDates = List<DateTime>.from(currentStreak.completedDates);
      
      if (!completedDates.any((date) => 
          date.year == dateOnly.year && 
          date.month == dateOnly.month && 
          date.day == dateOnly.day)) {
        completedDates.add(dateOnly);
        
        int newCurrentStreak = currentStreak.currentStreak + 1;
        int newLongestStreak = currentStreak.longestStreak;
        
        if (newCurrentStreak > newLongestStreak) {
          newLongestStreak = newCurrentStreak;
        }

        final updatedStreak = currentStreak.copyWith(
          currentStreak: newCurrentStreak,
          longestStreak: newLongestStreak,
          completedDates: completedDates,
          lastReadDate: dateOnly,
        );

        transaction.set(docRef, updatedStreak.toMap());
      }
    });
  }

  @override
  Future<List<DailyReadingModel>> getRecentReadings(String userId) async {
    final query = await firestore
        .collection('user_readings')
        .where('userId', isEqualTo: userId)
        .orderBy('lastRead', descending: true)
        .limit(5)
        .get();

    return query.docs
        .map((doc) => DailyReadingModel.fromMap(doc.data()))
        .toList();
  }
}