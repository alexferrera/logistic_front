abstract class DashboardEvent {}

class LoadPendingOrders extends DashboardEvent {
  final int tenantId;

  LoadPendingOrders(this.tenantId);
}

class CompleteOrderEvent extends DashboardEvent {
  final int tenantId;
  final int orderId;

  CompleteOrderEvent({
    required this.tenantId,
    required this.orderId,
  });
}

class ClearDashboard extends DashboardEvent {}


class LoadTodayStats extends DashboardEvent {
  final int tenantId;

  LoadTodayStats(this.tenantId);
}