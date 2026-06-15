import 'admin_record_status.dart';

class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.meterNumber,
    required this.status,
    required this.assignedCollectorId,
    required this.qrGenerated,
  });

  final String id;
  final String name;
  final String phone;
  final String address;
  final String meterNumber;
  final AdminRecordStatus status;
  final String? assignedCollectorId;
  final bool qrGenerated;

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? meterNumber,
    AdminRecordStatus? status,
    String? assignedCollectorId,
    bool clearAssignedCollector = false,
    bool? qrGenerated,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      meterNumber: meterNumber ?? this.meterNumber,
      status: status ?? this.status,
      assignedCollectorId: clearAssignedCollector
          ? null
          : assignedCollectorId ?? this.assignedCollectorId,
      qrGenerated: qrGenerated ?? this.qrGenerated,
    );
  }
}

class CustomerDraft {
  const CustomerDraft({
    required this.name,
    required this.phone,
    required this.address,
    required this.meterNumber,
    required this.assignedCollectorId,
    this.status = AdminRecordStatus.active,
    this.qrGenerated = false,
  });

  final String name;
  final String phone;
  final String address;
  final String meterNumber;
  final String? assignedCollectorId;
  final AdminRecordStatus status;
  final bool qrGenerated;
}
