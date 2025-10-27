import 'package:thefamilyaltar/core/utils/typedef.dart';

import '../entities/user.dart';

/// Contains all the methods specific for the authentication process
abstract class AuthRepository {
  /// Email/password sign in
  ResultFuture<LocalUser> emailSignIn(
      {required String email, required String password});

  /// Google sign in
  ResultFuture<LocalUser> googleSignIn();

  /// Apple sign in
  ResultFuture<LocalUser> appleSignIn();

  /// This method registers a new user on Firebase
  ResultFuture<LocalUser> createEmailUser(
      {required String email, required String password});

  /// Send password reset email
  ResultFuture<void> forgotPassword({required String email});

  /// This method signs out the user from Firebase
  ResultVoid signOut();

  /// This method gets the user session if the user is logged in
  ResultFuture<LocalUser?> getUserSession();
}
