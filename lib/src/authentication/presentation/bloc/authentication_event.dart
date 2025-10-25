part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateEmailUserEvent extends AuthenticationEvent {
  const CreateEmailUserEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email];
}

class EmailSignInEvent extends AuthenticationEvent {
  const EmailSignInEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email];
}

class GetUserSessionEvent extends AuthenticationEvent {
  const GetUserSessionEvent();
}

class SignOutUserEvent extends AuthenticationEvent {
  const SignOutUserEvent();
}
