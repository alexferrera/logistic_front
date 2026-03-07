import '../data/models/dashboard_order.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<OrderModel> orders;
  final int bottlesDelivered;
  final int ordersCompleted;

  DashboardLoaded({
    required this.orders,
    this.bottlesDelivered = 0,
    this.ordersCompleted = 0,
  });
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}