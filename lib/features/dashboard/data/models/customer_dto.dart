class CustomerDTO {
  final String name;
  final String phone;
  final String address;
  final int tenantId;

  CustomerDTO({
    required this.name,
    required this.phone,
    required this.address,
    required this.tenantId,
  });
}