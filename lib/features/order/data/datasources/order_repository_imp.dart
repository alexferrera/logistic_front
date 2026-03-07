import '../datasources/remote.dart';
import '../models/order.dart';
import '../repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final RemoteOrderDataSource remote;

  OrderRepositoryImpl(this.remote);

  @override
  Future<Order?> getPendingOrderForCustomer({
    required int tenantId,
    required int customerId,
  }) {
    return remote.getPendingOrderForCustomer(
      tenantId: tenantId,
      customerId: customerId,
    );
  }

  @override
  Future<Order> placeOrder({
    required int tenantId,
    required int userId,
    required int amount,
  }) {
    return remote.placeOrder(
      tenantId: tenantId,
      userId: userId,
      amount: amount,
    );
  }
}