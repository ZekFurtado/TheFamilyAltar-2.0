import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefamilyaltar/src/authentication/domain/entities/user.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/apple_sign_in.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/create_email_user.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/email_sign_in.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/forgot_password.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/google_sign_in.dart';
import 'package:thefamilyaltar/src/authentication/domain/usecases/sign_out.dart';

import '../../domain/usecases/get_user_session.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required CreateUser createUser,
      required EmailSignIn emailSignIn,
      required GoogleSignIn googleSignIn,
      required AppleSignIn appleSignIn,
      required ForgotPassword forgotPassword,
      required GetUserSession getUserSession,
      required SignOutUseCase signOutUser})
      : _createUser = createUser,
        _emailSignIn = emailSignIn,
        _googleSignIn = googleSignIn,
        _appleSignIn = appleSignIn,
        _forgotPassword = forgotPassword,
        _getUserSession = getUserSession,
        _signOutUseCase = signOutUser,
        super(const AuthenticationInitial()) {
    on<CreateEmailUserEvent>(_createEmailUserHandler);
    on<EmailSignInEvent>(_emailSignInHandler);
    on<GoogleSignInEvent>(_googleSignInHandler);
    on<AppleSignInEvent>(_appleSignInHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<GetUserSessionEvent>(_getUserSessionHandler);
    on<SignOutUserEvent>(_signOutUserEventHandler);
  }

  final CreateUser _createUser;
  final EmailSignIn _emailSignIn;
  final GoogleSignIn _googleSignIn;
  final AppleSignIn _appleSignIn;
  final ForgotPassword _forgotPassword;
  final GetUserSession _getUserSession;
  final SignOutUseCase _signOutUseCase;

  Future<void> _createEmailUserHandler(
      CreateEmailUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const CreatingUser());

    final result = await _createUser(
        CreateUserParams(email: event.email, password: event.password));

    result.fold(
        (failure) => emit(AuthenticationError(message: failure.statusCode)),
        (visitor) => emit(Authenticated(visitor)));
  }

  Future<void> _emailSignInHandler(
      EmailSignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SigningInEmailUser());

    final result = await _emailSignIn(
        EmailSignInParams(email: event.email, password: event.password));

    result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (visitor) => emit(Authenticated(visitor)));
  }

  Future<void> _getUserSessionHandler(
      GetUserSessionEvent event, Emitter<AuthenticationState> emit) async {
    emit(const FetchingUserSession());

    final result = await _getUserSession();

    result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (visitor) => emit(Authenticated(visitor)));
  }

  Future<void> _googleSignInHandler(
      GoogleSignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SigningInGoogleUser());

    final result = await _googleSignIn();

    result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (user) => emit(Authenticated(user)));
  }

  Future<void> _appleSignInHandler(
      AppleSignInEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SigningInAppleUser());

    final result = await _appleSignIn();

    result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (user) => emit(Authenticated(user)));
  }

  Future<void> _forgotPasswordHandler(
      ForgotPasswordEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SendingPasswordReset());

    final result = await _forgotPassword(ForgotPasswordParams(email: event.email));

    result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (_) => emit(const PasswordResetSent()));
  }

  Future<void> _signOutUserEventHandler(
      SignOutUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SigningOutUser());

    final result = await _signOutUseCase();

    result.fold(
        (failure) => emit(AuthenticationError(message: failure.message)),
        (visitor) => emit(const SignedOut()));
  }
}
