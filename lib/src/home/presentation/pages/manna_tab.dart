import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:thefamilyaltar/core/res/media_res.dart';
import 'package:thefamilyaltar/core/common/user_provider.dart';

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
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final authState = context.read<AuthenticationBloc>().state;
    log('_loadInitialData: authState = ${authState.runtimeType}');
    
    context.read<HomeBloc>().add(const LoadTodaysReading());
    
    if (authState is Authenticated && authState.visitor != null && authState.visitor!.uid != null) {
      log('_loadInitialData: Setting currentUserId to ${authState.visitor!.uid}');
      setState(() {
        currentUserId = authState.visitor!.uid;
      });
      context.read<HomeBloc>().add(LoadUserStreak(userId: currentUserId!));
    } else {
      log('_loadInitialData: User not authenticated or visitor is null');
      // Clear user data if not authenticated
      setState(() {
        currentUserId = null;
        userStreak = null;
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthenticationBloc>().add(const SignOutUserEvent());
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
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
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final isLoggedIn = userProvider.user != null;
              return PopupMenuButton<String>(
                icon: Icon(
                  isLoggedIn ? Icons.account_circle : Icons.person_outline,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'login':
                      Navigator.pushNamed(context, '/login');
                      break;
                    case 'settings':
                      Navigator.pushNamed(context, '/settings');
                      break;
                    case 'logout':
                      _showLogoutDialog(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  if (isLoggedIn) {
                    return [
                      PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings, size: 20),
                            SizedBox(width: 12),
                            Text('Settings'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, size: 20),
                            SizedBox(width: 12),
                            Text('Sign Out'),
                          ],
                        ),
                      ),
                    ];
                  } else {
                    return [
                      PopupMenuItem<String>(
                        value: 'login',
                        child: Row(
                          children: [
                            Icon(Icons.login, size: 20),
                            SizedBox(width: 12),
                            Text('Sign In'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings, size: 20),
                            SizedBox(width: 12),
                            Text('Settings'),
                          ],
                        ),
                      ),
                    ];
                  }
                },
              );
            },
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
                  selectedDay = DateTime.now();
                  isShowingTodaysReading = true;
                });
              } else if (state is ReadingByDateLoaded) {
                setState(() {
                  currentReading = state.reading;
                  isLoading = false;
                  selectedDay = state.selectedDay;
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
              log('AuthenticationBloc state changed: ${state.runtimeType}');
              
              if (state is Authenticated && state.visitor != null && state.visitor!.uid != null) {
                // User is authenticated, check if we need to update currentUserId
                final newUserId = state.visitor!.uid;
                log('User authenticated with UID: $newUserId, current UID: $currentUserId');
                
                if (currentUserId != newUserId) {
                  log('Updating currentUserId to $newUserId');
                  setState(() {
                    currentUserId = newUserId;
                  });
                  // Load user streak data whenever user ID changes
                  context.read<HomeBloc>().add(LoadUserStreak(userId: currentUserId!));
                }
              } else if (state is SignedOut) {
                log('User signed out, clearing currentUserId');
                // User signed out, clear the current user ID
                setState(() {
                  currentUserId = null;
                  userStreak = null;
                });
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            _loadInitialData();
            // Also reload user streak if we have a current user
            if (currentUserId != null) {
              context.read<HomeBloc>().add(LoadUserStreak(userId: currentUserId!));
            }
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
                      // Show login encouragement banner for non-authenticated users
                      if (currentUserId == null)
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primaryContainer,
                                Theme.of(context).colorScheme.secondaryContainer,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_circle_outlined,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to track your reading streaks',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Save notes, build reading habits, and track your spiritual journey',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                          selectedDay: selectedDay,
                          onDateSelected: (selectedDate) {
                            context.read<HomeBloc>().add(
                              LoadReadingByDate(date: selectedDate),
                            );
                            selectedDay = selectedDate;
                          },
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.attribution,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Content provided by Voice of God Recordings Inc.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        // Show default calendar even for new/unauthenticated users
                        ReadingCalendar(
                          streak: UserStreak(
                            userId: currentUserId ?? 'guest',
                            currentStreak: 0,
                            longestStreak: 0,
                            completedDates: const [],
                            lastReadDate: null,
                            firstAppUseDate: null, // No first use date means no red markers
                          ),
                          onDateSelected: (selectedDate) {
                            context.read<HomeBloc>().add(
                              LoadReadingByDate(date: selectedDate),
                            );
                          },
                        ),
                        // const SizedBox(height: 16),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.attribution,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Content provided by Voice of God Recordings Inc.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontSize: 11,
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