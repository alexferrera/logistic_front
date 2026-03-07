import '../data/models/user.dart';

abstract class AuthState {}

class LoginInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final User user;

  LoginSuccess(this.user);
}

class LoginFailure extends AuthState {
  final String message;

  LoginFailure(this.message);
}

class LogoutSuccess extends AuthState {}
class AuthInitialLoading extends AuthState {}
