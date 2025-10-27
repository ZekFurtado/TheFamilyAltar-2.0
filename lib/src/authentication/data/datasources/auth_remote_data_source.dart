import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thefamilyaltar/core/errors/exceptions.dart';

import '../models/local_user_model.dart';

abstract class AuthRemoteDataSource {
  /// Email/password sign in
  Future<LocalUserModel> emailSignIn(
      {required String email, required String password});

  /// Google sign in
  Future<LocalUserModel> googleSignIn();

  /// Apple sign in
  Future<LocalUserModel> appleSignIn();

  /// Register new user with email/password
  Future<LocalUserModel> createEmailUser(
      {required String email, required String password});

  /// Send password reset email
  Future<void> forgotPassword({required String email});

  /// Set username for the user
  Future<void> setUsername({required String username});

  /// Sign out the user
  Future<void> signOut();

  /// Get current user session
  Future<LocalUserModel?> getUserSession();
}

/// This class deals with the authentication related remote API sources
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this.firebaseAuth) : _googleSignIn = GoogleSignIn();

  /// This method is automatically called due to the dependency injection at
  /// runtime. It calls the Firebase API for signing in the user.
  @override
  Future<LocalUserModel> emailSignIn(
      {required String email, required String password}) async {
    try {
      return await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        return LocalUserModel.fromFirebase(userCredential.user);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential" ||
          e.code == "INVALID_LOGIN_CREDENTIALS" ||
          e.code == "wrong-password" ||
          e.code == "user-not-found") {
        throw InvalidCredentialsException(
            statusCode: e.code,
            message:
                "The credentials you have provided are invalid. Please try again");
      } else if (e.code == "too-many-requests") {
        throw FirebaseTooManyRequests(
            statusCode: e.code,
            message: "Too many attempts. Please wait for some time");
      } else if (e.code == "user-disabled") {
        throw UserDisabled(
            statusCode: e.code,
            message: "This user has been disabled. Please contact support");
      } else {
        throw AuthException(
            statusCode: e.code,
            message: e.message ?? "An authentication error occurred");
      }
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    } catch (e) {
      throw const AuthException(
          statusCode: "error", message: "An authentication error occurred");
    }
  }

  /// This method is automatically called due to the dependency injection at
  /// runtime. It calls the Firebase API for registering the user.
  @override
  Future<LocalUserModel> createEmailUser(
      {required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final visitor = LocalUserModel.fromFirebase(userCredential.user);

      return visitor;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          statusCode: e.code,
          message: e.message ?? "An error occurred while creating the user");
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    }
  }

  /// This method is automatically called due to the dependency injection at
  /// runtime. It calls the Firebase API for setting the username of the user.
  @override
  Future<void> setUsername({required String username}) async {
    try {
      await firebaseAuth.currentUser?.updateDisplayName(username);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          statusCode: e.code, message: e.message ?? "An error occurred");
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    }
  }

  /// This method is automatically called due to the dependency injection at
  /// runtime. It calls the Firebase API for signing out the user.
  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          statusCode: e.code, message: e.message ?? "An error occurred");
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    }
  }

  @override
  Future<LocalUserModel> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw const AuthException(
            statusCode: "cancelled", message: "Google sign in was cancelled");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      return LocalUserModel.fromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          statusCode: e.code,
          message: e.message ?? "An error occurred during Google sign in");
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    } catch (e) {
      throw const AuthException(
          statusCode: "error", message: "An error occurred during Google sign in");
    }
  }

  @override
  Future<LocalUserModel> appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final userCredential = await firebaseAuth.signInWithCredential(oauthCredential);
      return LocalUserModel.fromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          statusCode: e.code,
          message: e.message ?? "An error occurred during Apple sign in");
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    } catch (e) {
      throw const AuthException(
          statusCode: "error", message: "An error occurred during Apple sign in");
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          statusCode: e.code,
          message: e.message ?? "An error occurred while sending password reset email");
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    }
  }

  @override
  Future<LocalUserModel?> getUserSession() async {
    try {
      final user = firebaseAuth.currentUser;
      print("USER: $user");

      if (user == null) {
        return null;
      }

      final visitor = LocalUserModel.fromFirebase(user);

      return visitor;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          statusCode: e.code,
          message: e.message ?? "An error occurred while creating the user");
    } on SocketException {
      throw const NetworkException(
          statusCode: "404",
          message: "No Internet. Please check your network connection");
    }
  }
}
