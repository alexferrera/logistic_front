class User {
  final int userId;
  final int tenantId;
  final int customerId;
  final String role;
  final String name;

  User({
    required this.userId,
    required this.tenantId,
    required this.customerId,
    required this.role,
    required this.name
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      tenantId: json['tenant_id'],
      role: json['role'],
      customerId: json['customer_id'],
      name: json['name'] ?? ''
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'tenant_id': tenantId,
    'customer_id': customerId,
    'role': role,
    'name': name
  };
}