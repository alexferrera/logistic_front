import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'models/user.dart';

class SessionStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveUserSession(User user) async {
    await _storage.write(key: 'isLoggedIn', value: 'true');
    await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  Future<void> clearUserSession() async {
    await _storage.delete(key: 'isLoggedIn');
    await _storage.delete(key: 'user');
  }

  Future<User?> getUserSession() async {
    final isLoggedIn = await _storage.read(key: 'isLoggedIn');
    if (isLoggedIn == 'true') {
      final userJson = await _storage.read(key: 'user');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    }
    return null;
  }
}