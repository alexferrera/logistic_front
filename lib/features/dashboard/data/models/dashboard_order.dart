class OrderModel {
  final int id;
  final int tenantId;
  final int customerId;
  final String customerName;
  final String address;
  final String phone;
  final int quantity;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.tenantId,
    required this.customerId,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.quantity,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      tenantId: json['tenant_id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      address: json['address'],
      phone: json['phone'],
      quantity: json['quantity'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}