import 'package:logistiQ/features/auth/data/models/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
    required String phone,
  });
}
