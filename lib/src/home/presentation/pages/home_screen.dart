import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/injection_container.dart';
import '../bloc/home_bloc.dart';
import '../widgets/reading_calendar.dart';
import '../widgets/streak_display.dart';
import '../widgets/todays_reading_card.dart';
import 'manna_tab.dart';
import 'bible_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>(),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            MannaTab(),
            BibleTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories),
              label: 'Manna',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Bible',
            ),
          ],
        ),
      ),
    );
  }
}