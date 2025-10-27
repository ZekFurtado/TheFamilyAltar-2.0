import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thefamilyaltar/core/res/media_res.dart';

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
  bool isLoading = true;
  bool isShowingTodaysReading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is Authenticated && authState.visitor != null) {
      currentUserId = authState.visitor!.uid;
      context.read<HomeBloc>().add(const LoadTodaysReading());
      context.read<HomeBloc>().add(LoadUserStreak(userId: currentUserId!));
    } else {
      // Still load today's reading even if not authenticated
      context.read<HomeBloc>().add(const LoadTodaysReading());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(MediaRes.logoCropped),
        ),
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is TodaysReadingLoaded) {
                setState(() {
                  currentReading = state.reading;
                  isLoading = false;
                  isShowingTodaysReading = true;
                });
              } else if (state is ReadingByDateLoaded) {
                setState(() {
                  currentReading = state.reading;
                  isLoading = false;
                  isShowingTodaysReading = false;
                });
              } else if (state is UserStreakLoaded) {
                setState(() {
                  userStreak = state.streak;
                });
              } else if (state is HomeError) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is Authenticated && state.visitor != null && currentUserId == null) {
                // User just signed in, load their streak data
                setState(() {
                  currentUserId = state.visitor!.uid;
                });
                context.read<HomeBloc>().add(LoadUserStreak(userId: currentUserId!));
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            _loadInitialData();
          },
          child: isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Loading today's reading..."),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      if (currentReading != null)
                        Column(
                          children: [
                            TodaysReadingCard(
                              reading: currentReading!,
                              isToday: isShowingTodaysReading,
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
                            if (!isShowingTodaysReading)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      context.read<HomeBloc>().add(const LoadTodaysReading());
                                    },
                                    icon: Icon(
                                      Icons.today,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    label: Text(
                                      "Back to Today's Reading",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      else
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Today's Reading Unavailable",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Please check your internet connection and try again.",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
                      ] else if (currentUserId != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.timeline,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Start Your Reading Journey",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Begin reading daily to build your streak and track your spiritual growth.",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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