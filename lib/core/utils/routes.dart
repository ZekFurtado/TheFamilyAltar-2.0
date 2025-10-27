import 'package:flutter/material.dart';
import 'package:thefamilyaltar/src/authentication/presentation/pages/login.dart';
import 'package:thefamilyaltar/src/authentication/presentation/pages/signup_screen.dart';
import 'package:thefamilyaltar/src/home/presentation/pages/home_screen.dart';
import 'package:thefamilyaltar/src/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:thefamilyaltar/src/settings/presentation/pages/settings_screen.dart';

class Routes {
  static var routes = {
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignupScreen(),
    '/home': (context) => const HomeScreen(),
    '/onboarding': (context) => const OnboardingScreen(),
    '/settings': (context) => const SettingsScreen(),
  };
}

// Placeholder screens until actual screens are implemented
class _PlaceholderHomeScreen extends StatelessWidget {
  const _PlaceholderHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64),
            SizedBox(height: 16),
            Text(
              'Welcome to The Family Altar!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Home screen coming soon...'),
          ],
        ),
      ),
    );
  }
}

