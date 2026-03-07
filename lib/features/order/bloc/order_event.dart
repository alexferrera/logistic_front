import 'package:logistiQ/features/order/data/models/order.dart';

abstract class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final int tenantId;
  final int userId;
  final int amount;

  CreateOrderEvent({
    required this.tenantId,
    required this.userId,
    required this.amount,
  });
}

class GetOrderEvent extends OrderEvent {
  final int tenantId;
  final int customerId;

  GetOrderEvent({required this.tenantId, required this.customerId});
}

class RefreshOrderEvent extends OrderEvent{
  final int tenantId;
  final int customerId;

  RefreshOrderEvent({required this.tenantId, required this.customerId});
}