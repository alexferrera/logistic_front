
import '../models/dashboard_order.dart';
import '../models/today_stats.dart';

abstract class DashboardRepository {
  Future<List<OrderModel>> getPendingOrders(int tenantId);
  Future<void> completeOrder(int orderId);
  Future<TodayStatsModel> getTodayStats(int tenantId);
}