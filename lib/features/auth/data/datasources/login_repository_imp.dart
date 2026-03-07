import '../models/user.dart';
import 'remote_datasource.dart';
import '../repositories/login_repo.dart';

class LoginRepositoryImp implements AuthRepository {
  final RemoteDatasource datasource;

  LoginRepositoryImp({required this.datasource});

  @override
  Future<User> login({
    String? email,
    String? password,
    String? phone,
  }) async {
    return await datasource.login(
      email: email,
      password: password,
      phone: phone,
    );
  }
}