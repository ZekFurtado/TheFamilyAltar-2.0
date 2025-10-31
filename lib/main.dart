// import 'dart:ui_web';

import 'package:thefamilyaltar/core/utils/routes.dart';
import 'package:thefamilyaltar/core/utils/theme.dart';
import 'package:thefamilyaltar/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thefamilyaltar/src/home/presentation/bloc/home_bloc.dart';

import 'core/common/user_provider.dart';
import 'core/services/injection_container.dart';
import 'core/utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  
  // Pass all uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  // Initialize dependency injection
  await init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthenticationBloc>()),
        BlocProvider(create: (context) => sl<HomeBloc>()),
      ],
      child: const TheFamilyAltarApp(),
    ),
  ));
}

class TheFamilyAltarApp extends StatelessWidget {
  const TheFamilyAltarApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Family Altar',
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      home: const RouteResolver(),
      navigatorObservers: [observer],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
        Locale('mr', ''), // Marathi
        Locale('gu', ''), // Gujarati
      ],
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: AppTheme.lightScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: AppTheme.darkScheme,
        useMaterial3: true,
      ),
    );
  }
}

class RouteResolver extends StatefulWidget {
  const RouteResolver({super.key});

  @override
  State<RouteResolver> createState() => _RouteResolverState();
}

class _RouteResolverState extends State<RouteResolver> {
  @override
  void initState() {
    super.initState();
    _initializeRoute();
  }

  Future<void> _initializeRoute() async {
    final bloc = context.read<AuthenticationBloc>();
    
    // Check for user session
    bloc.add(const GetUserSessionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) async {
        if (state is Authenticated) {
          // User is logged in, update UserProvider and navigate to home
          print('state.visitor');
          print(state.visitor);
          if(state.visitor != null){
            // Update UserProvider with authenticated user
            context.read<UserProvider>().user = state.visitor;
            await _navigateToHome();
          }
          else {
            await _checkFirstTimeAndNavigate(context);
          }
        } else if (state is AuthenticationError || state is SignedOut) {
          // Clear UserProvider when not authenticated
          context.read<UserProvider>().user = null;
          // Check if first time user for onboarding
          await _checkFirstTimeAndNavigate(context);
        }
      },
      builder: (context, state) {
        // Show loading screen while determining route
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToHome() async {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _checkFirstTimeAndNavigate(context) async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('is_first_time') ?? true;

    if (isFirstTime) {
      // Mark as not first time
      await prefs.setBool('is_first_time', false);
      // Navigate to onboarding
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      // Navigate to login
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
