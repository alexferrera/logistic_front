import '../data/models/customer_dto.dart';

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

class AddCustomerEvent extends DashboardEvent {
  final CustomerDTO customer;

  AddCustomerEvent({required this.customer});
}

class LoadCustomers extends DashboardEvent {
  final int tenantId;

  LoadCustomers(this.tenantId);
}

class RefreshCustomersRequested extends DashboardEvent {
  final int tenantId;

  RefreshCustomersRequested(this.tenantId);
}

class RemoveCustomerEvent extends DashboardEvent {
  final int tenantId;
  final int userId;

  RemoveCustomerEvent({required this.tenantId, required this.userId});
}
