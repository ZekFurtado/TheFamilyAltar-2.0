import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../domain/entities/daily_reading.dart';
import '../../domain/entities/user_streak.dart';
import '../bloc/home_bloc.dart';
import '../widgets/reading_calendar.dart';
import '../widgets/streak_display.dart';
import '../widgets/todays_reading_card.dart';
import 'reading_detail_screen.dart';

class MannaTab extends StatefulWidget {
  const MannaTab({super.key});

  @override
  State<MannaTab> createState() => _MannaTabState();
}

class _MannaTabState extends State<MannaTab> {
  DailyReading? currentReading;
  UserStreak? userStreak;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is Authenticated && authState.visitor != null) {
      currentUserId = authState.visitor!.uid;
      context.read<HomeBloc>().add(const LoadTodaysReading());
      context.read<HomeBloc>().add(LoadUserStreak(userId: currentUserId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "The Family Altar",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to settings
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is TodaysReadingLoaded) {
            setState(() {
              currentReading = state.reading;
            });
          } else if (state is ReadingByDateLoaded) {
            setState(() {
              currentReading = state.reading;
            });
          } else if (state is UserStreakLoaded) {
            setState(() {
              userStreak = state.streak;
            });
          } else if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _loadInitialData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 8),
                if (currentReading != null)
                  TodaysReadingCard(
                    reading: currentReading!,
                    onReadMore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadingDetailScreen(
                            reading: currentReading!,
                            userId: currentUserId,
                          ),
                        ),
                      );
                    },
                  ),
                if (userStreak != null) ...[
                  const SizedBox(height: 8),
                  StreakDisplay(streak: userStreak!),
                  const SizedBox(height: 16),
                  ReadingCalendar(
                    streak: userStreak!,
                    onDateSelected: (selectedDate) {
                      context.read<HomeBloc>().add(
                        LoadReadingByDate(date: selectedDate),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}