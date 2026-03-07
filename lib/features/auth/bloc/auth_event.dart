abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String phone;

  LoginSubmitted({required this.email, required this.password, required this.phone});
}

class RestoreSession extends AuthEvent {}
class LogoutRequested extends AuthEvent {}
