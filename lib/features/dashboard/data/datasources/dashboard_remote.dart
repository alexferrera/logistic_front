import 'package:dio/dio.dart';
import '../models/customer_dto.dart';
import '../models/dashboard_order.dart';
import '../models/today_stats.dart';

class DashboardRemoteDatasource {
  final Dio dio;

  DashboardRemoteDatasource({required this.dio});

  Future<List<OrderModel>> getPendingOrders(int tenantId) async {
    try {
      final response = await dio.get("/tenants/$tenantId/orders/pending");

      final List data = response.data["result"];
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      } else {
        rethrow;
      }
    }
  }

  Future<void> completeOrder(int tenantId, int orderId) async {
    await dio.patch(
      "/tenants/$tenantId/orders/$orderId/complete",
    );
  }

  Future<TodayStatsModel> getTodayStats(int tenantId) async {
    final response = await dio.get(
      "/tenants/$tenantId/orders/today/stats",
    );

    final data = response.data["result"];

    return TodayStatsModel.fromJson(data);
  }

  Future<void> createCustomer(CustomerDTO customer) async {
    await dio.post(
      "/customers",
      data: {
        "name": customer.name,
        "phone": customer.phone,
        "address": customer.address,
        "tenant_id": customer.tenantId,
      },
    );
  }
}