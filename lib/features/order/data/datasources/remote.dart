import 'package:dio/dio.dart';
import '../../../auth/data/models/api_response.dart';
import '../models/order.dart';

class RemoteOrderDataSource {
  final Dio dio;

  RemoteOrderDataSource({required this.dio});

  Future<Order?> getPendingOrderForCustomer({
    required int tenantId,
    required int customerId,
  }) async {
    try {
      final response = await dio.get(
        '/tenants/$tenantId/customer/$customerId/orders/pending',
      );

      final data = response.data['result'];

      if (data == null) return null;

      return Order.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Order> placeOrder({
    required int tenantId,
    required int userId,
    required int amount,
  }) async {
    final response = await dio.post(
      '/orders',
      data: {
        "tenant_id": tenantId,
        "user_id": userId,
        "amount": amount,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data);
    print("RESPONSE DATA:");
    print(response.data);
    if (apiResponse.success && apiResponse.data != null) {
      return Order.fromJson(apiResponse.data!);
    }

    throw Exception(apiResponse.message);
  }
}