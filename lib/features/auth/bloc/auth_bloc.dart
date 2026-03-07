import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/login_repo.dart';
import '../data/session_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final SessionStorage sessionStorage;

  AuthBloc({required this.repository, required this.sessionStorage})
    : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await repository.login(
          email: event.email,
          password: event.password,
          phone: event.phone,
        );

        await sessionStorage.clearUserSession();
        await sessionStorage.saveUserSession(user);

        emit(LoginSuccess(user));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<RestoreSession>((event, emit) async {
      emit(AuthInitialLoading());
      final user = await sessionStorage.getUserSession();
      if (user != null) {
        emit(LoginSuccess(user));
      } else {
        emit(LoginInitial());
      }
    });

    on<LogoutRequested>((event, emit) async {
      await sessionStorage.clearUserSession();
      emit(LoginInitial());
    });
  }
}
