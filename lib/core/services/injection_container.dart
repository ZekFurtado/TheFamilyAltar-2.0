import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thefamilyaltar/src/authentication/data/datasources/auth_local_data_source.dart';
import 'package:thefamilyaltar/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:thefamilyaltar/src/authentication/data/repositories/auth_repository_impl.dart';
import 'package:thefamilyaltar/src/authentication/domain/repositories/auth_repository.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/apple_sign_in.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/create_email_user.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/email_sign_in.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/forgot_password.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/get_user_session.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/google_sign_in.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/sign_out.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/delete_account.dart';
import 'package:thefamilyaltar/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:thefamilyaltar/src/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:thefamilyaltar/src/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:thefamilyaltar/src/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:thefamilyaltar/src/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:thefamilyaltar/src/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:thefamilyaltar/src/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:thefamilyaltar/src/home/data/datasources/home_remote_data_source.dart';
import 'package:thefamilyaltar/src/home/data/repositories/home_repository_impl.dart';
import 'package:thefamilyaltar/src/home/domain/repositories/home_repository.dart';
import 'package:thefamilyaltar/src/home/domain/usecases/get_todays_reading.dart';
import 'package:thefamilyaltar/src/home/domain/usecases/get_reading_by_date.dart';
import 'package:thefamilyaltar/src/home/domain/usecases/get_user_streak.dart';
import 'package:thefamilyaltar/src/home/domain/usecases/update_user_streak.dart';
import 'package:thefamilyaltar/src/home/presentation/bloc/home_bloc.dart';
import 'package:thefamilyaltar/src/notes/data/datasources/notes_remote_data_source.dart';
import 'package:thefamilyaltar/src/notes/data/repositories/notes_repository_impl.dart';
import 'package:thefamilyaltar/src/notes/domain/repositories/notes_repository.dart';
import 'package:thefamilyaltar/src/notes/domain/usecases/get_notes_by_reading.dart';
import 'package:thefamilyaltar/src/notes/domain/usecases/get_highlights_by_reading.dart';
import 'package:thefamilyaltar/src/notes/domain/usecases/save_note.dart';
import 'package:thefamilyaltar/src/notes/domain/usecases/save_highlight.dart';
import 'package:thefamilyaltar/src/notes/domain/usecases/delete_note.dart';
import 'package:thefamilyaltar/src/notes/domain/usecases/delete_highlight.dart';
import 'package:thefamilyaltar/src/notes/presentation/bloc/notes_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl

    /// APP LOGIC

    /// Authentication
    ..registerFactory(() => AuthenticationBloc(
        createUser: sl(),
        emailSignIn: sl(),
        googleSignIn: sl(),
        appleSignIn: sl(),
        forgotPassword: sl(),
        getUserSession: sl(),
        signOutUser: sl(),
        deleteAccount: sl()))

    /// Onboarding
    ..registerFactory(() => OnboardingBloc(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl()))

    /// Home
    ..registerFactory(() => HomeBloc(
        getTodaysReading: sl(),
        getReadingByDate: sl(),
        getUserStreak: sl(),
        updateUserStreak: sl()))

    /// Notes
    ..registerFactory(() => NotesBloc(
        getNotesByReading: sl(),
        getHighlightsByReading: sl(),
        saveNote: sl(),
        saveHighlight: sl(),
        deleteNote: sl(),
        deleteHighlight: sl()))

    /// USE CASES

    /// Authentication
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => EmailSignIn(sl()))
    ..registerLazySingleton(() => GoogleSignIn(sl()))
    ..registerLazySingleton(() => AppleSignIn(sl()))
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => GetUserSession(sl()))
    ..registerLazySingleton(() => SignOutUseCase(sl()))
    ..registerLazySingleton(() => DeleteAccount(sl()))

    /// Onboarding
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))

    /// Home
    ..registerLazySingleton(() => GetTodaysReading(sl()))
    ..registerLazySingleton(() => GetReadingByDate(sl()))
    ..registerLazySingleton(() => GetUserStreak(sl()))
    ..registerLazySingleton(() => UpdateUserStreak(sl()))

    /// Notes
    ..registerLazySingleton(() => GetNotesByReading(sl()))
    ..registerLazySingleton(() => GetHighlightsByReading(sl()))
    ..registerLazySingleton(() => SaveNote(sl()))
    ..registerLazySingleton(() => SaveHighlight(sl()))
    ..registerLazySingleton(() => DeleteNote(sl()))
    ..registerLazySingleton(() => DeleteHighlight(sl()))

    /// REPOSITORIES

    /// Authentication
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()))

    /// Onboarding
    ..registerLazySingleton<OnboardingRepository>(
        () => OnboardingRepositoryImpl(sl()))

    /// Home
    ..registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(remoteDataSource: sl()))

    /// Notes
    ..registerLazySingleton<NotesRepository>(
        () => NotesRepositoryImpl(remoteDataSource: sl()))

    /// DATA SOURCES

    /// Authentication
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl()))

    /// Onboarding
    ..registerLazySingleton<OnboardingLocalDataSource>(
        () => OnboardingLocalDataSourceImpl(sl()))

    /// Home
    ..registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(firestore: sl()))

    /// Notes
    ..registerLazySingleton<NotesRemoteDataSource>(
        () => NotesRemoteDataSourceImpl(firestore: sl()))

    /// EXTERNAL DEPENDENCIES
    ..registerLazySingleton(() => sharedPreferences)

    /// Firebase Services
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance)
    ..registerLazySingleton(() => FirebaseAnalytics.instance)
    ..registerLazySingleton(() => FirebaseCrashlytics.instance);
}
