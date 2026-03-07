import '../models/order.dart';

abstract class OrderRepository {
  Future<Order?> getPendingOrderForCustomer({
    required int tenantId,
    required int customerId,
  });

  Future<Order> placeOrder({
    required int tenantId,
    required int userId,
    required int amount,
  });
}