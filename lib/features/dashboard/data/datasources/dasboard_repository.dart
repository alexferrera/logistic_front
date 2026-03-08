import '../../../auth/data/models/api_response.dart';
import '../models/customer_dto.dart';
import '../models/dashboard_order.dart';
import '../models/today_stats.dart';
import 'dashboard_remote.dart';

class DashboardRepository {
  final DashboardRemoteDatasource remote;

  DashboardRepository({required this.remote});

  Future<List<OrderModel>> getPendingOrders(int tenantId) {
    return remote.getPendingOrders(tenantId);
  }

  Future<void> completeOrder(int tenantId, int orderId) {
    return remote.completeOrder(tenantId, orderId);
  }

  Future<TodayStatsModel> getTodayStats(int tenantId) {
    return remote.getTodayStats(tenantId);
  }

  Future<void> createCustomer(CustomerDTO customer) {
    return remote.createCustomer(customer);
  }

  Future<List<CustomerDTO>> getCustomers(int tenantId) {
    return remote.getCustomers(tenantId);
  }

  Future<ApiResponse> removeCustomer(int tenantId, int userId) {
    return remote.removeCustomer(tenantId, userId);
  }
}
