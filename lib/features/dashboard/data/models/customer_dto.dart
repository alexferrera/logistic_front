class CustomerDTO {
  final String name;
  final String phone;
  final String address;
  final int tenantId;
  final int? userId;

  CustomerDTO({
    required this.name,
    required this.phone,
    required this.address,
    required this.tenantId,
    this.userId,
  });

  factory CustomerDTO.fromJson(Map<String, dynamic> json) {
    return CustomerDTO(
      name: json["name"],
      phone: json["phone"],
      address: json["address"],
      tenantId: json["tenant_id"],
      userId: json["user_id"],
    );
  }
}