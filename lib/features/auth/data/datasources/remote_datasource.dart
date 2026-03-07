import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/user.dart';

class RemoteDatasource {
  final Dio dio;

  RemoteDatasource({required this.dio});

  Future<User> login({
    String? email,
    String? password,
    String? phone,
  }) async {
    try {
      Map<String, dynamic> body = {};

      if (email != "" && password != "") {
        body = {"email": email, "password": password};
      } else if (phone != "") {
        body = {"phone": phone};
      } else {
        throw Exception("Debe proporcionar email+password o phone");
      }

      final response = await dio.post('/auth/login', data: body);

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(response.data);
        if (apiResponse.success && apiResponse.data != null) {
          return User.fromJson(apiResponse.data!);
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception("Error en servidor: ${response.statusCode}");
      }
    } on DioError catch (e) {
      String errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception(errorMessage);
    }
  }
}