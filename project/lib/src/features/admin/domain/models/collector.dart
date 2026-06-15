import 'admin_record_status.dart';

class Collector {
  const Collector({
    required this.id,
    required this.name,
    required this.phone,
    required this.area,
    required this.status,
    required this.customerIds,
  });

  final String id;
  final String name;
  final String phone;
  final String area;
  final AdminRecordStatus status;
  final List<String> customerIds;

  Collector copyWith({
    String? id,
    String? name,
    String? phone,
    String? area,
    AdminRecordStatus? status,
    List<String>? customerIds,
  }) {
    return Collector(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      area: area ?? this.area,
      status: status ?? this.status,
      customerIds: customerIds ?? this.customerIds,
    );
  }
}

class CollectorDraft {
  const CollectorDraft({
    required this.name,
    required this.phone,
    required this.area,
    this.status = AdminRecordStatus.active,
  });

  final String name;
  final String phone;
  final String area;
  final AdminRecordStatus status;
}
