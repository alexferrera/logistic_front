import 'dart:ffi';

class Order {
  final int orderId;
  final int customerId;
  final int tenantId;
  final int quantity;
  final String status;

  Order({
    required this.orderId,
    required this.customerId,
    required this.tenantId,
    required this.quantity,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['id'],
      customerId: json['customer_id'],
      tenantId: json['tenant_id'],
      quantity: json['quantity'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "order_id": orderId,
      "customer_id": customerId,
      "tenant_id": tenantId,
      "quantity": quantity,
      "status": status,
    };
  }
}