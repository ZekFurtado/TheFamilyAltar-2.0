import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thefamilyaltar/src/authentication/data/datasources/auth_local_data_source.dart';
import 'package:thefamilyaltar/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:thefamilyaltar/src/authentication/data/repositories/auth_repository_impl.dart';
import 'package:thefamilyaltar/src/authentication/domain/repositories/auth_repository.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/create_email_user.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/email_sign_in.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/get_user_session.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/sign_out.dart';
import 'package:thefamilyaltar/src/authentication/presentation/bloc/authentication_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl

    /// APP LOGIC

    /// Authentication
    ..registerFactory(() => AuthenticationBloc(
        createUser: sl(),
        emailSignIn: sl(),
        getUserSession: sl(),
        signOutUser: sl()))
    // () => AuthenticationCubit(createUser: sl(), emailSignIn: sl()))

    /// Home
    // ..registerFactory(() => HomeBloc())

    /// USE CASES

    /// Authentication
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => EmailSignIn(sl()))
    ..registerLazySingleton(() => GetUserSession(sl()))
    ..registerLazySingleton(() => SignOutUseCase(sl()))

    /// REPOSITORIES

    /// Authentication
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()))

    /// DATA SOURCES

    /// Authentication
    ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl()))

    /// EXTERNAL DEPENDENCIES
    ..registerLazySingleton(() => sharedPreferences)

    /// Authentication
    ..registerLazySingleton(() => FirebaseAuth.instance);
}
