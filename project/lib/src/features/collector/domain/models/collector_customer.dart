class CollectorCustomer {
  const CollectorCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.meterNumber,
    required this.meterToken,
    required this.notes,
  });

  final String id;
  final String name;
  final String phone;
  final String address;
  final String meterNumber;
  final String meterToken;
  final String notes;
}
