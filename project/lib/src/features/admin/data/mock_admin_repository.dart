import '../domain/models/admin_record_status.dart';
import '../domain/models/collector.dart';
import '../domain/models/customer.dart';
import '../domain/repositories/admin_repository.dart';

class MockAdminRepository implements AdminRepository {
  MockAdminRepository._();

  static final MockAdminRepository instance = MockAdminRepository._().._seed();

  final List<Customer> _customers = [];
  final List<Collector> _collectors = [];
  int _customerSequence = 100;
  int _collectorSequence = 20;

  @override
  List<Customer> listCustomers() => List.unmodifiable(_customers);

  @override
  List<Collector> listCollectors() => List.unmodifiable(_collectors);

  @override
  Customer createCustomer(CustomerDraft draft) {
    final customer = Customer(
      id: 'customer-${_customerSequence++}',
      name: draft.name,
      phone: draft.phone,
      address: draft.address,
      meterNumber: draft.meterNumber,
      status: draft.status,
      assignedCollectorId: draft.assignedCollectorId,
      qrGenerated: draft.qrGenerated,
    );
    _customers.add(customer);
    _syncCollectorAssignments();
    return customer;
  }

  @override
  Customer updateCustomer(Customer customer) {
    final index = _customers.indexWhere((item) => item.id == customer.id);
    if (index == -1) {
      throw ArgumentError('Customer not found: ${customer.id}');
    }
    _customers[index] = customer;
    _syncCollectorAssignments();
    return customer;
  }

  @override
  Customer deactivateCustomer(String customerId) {
    final customer = _customerById(
      customerId,
    ).copyWith(status: AdminRecordStatus.inactive);
    return updateCustomer(customer);
  }

  @override
  void deleteCustomer(String customerId) {
    _customers.removeWhere((customer) => customer.id == customerId);
    _syncCollectorAssignments();
  }

  @override
  Customer assignCollectorToCustomer(String customerId, String? collectorId) {
    final customer = _customerById(customerId).copyWith(
      assignedCollectorId: collectorId,
      clearAssignedCollector: collectorId == null,
    );
    return updateCustomer(customer);
  }

  @override
  Customer setCustomerQrGenerated(String customerId, bool qrGenerated) {
    final customer = _customerById(
      customerId,
    ).copyWith(qrGenerated: qrGenerated);
    return updateCustomer(customer);
  }

  @override
  Collector createCollector(CollectorDraft draft) {
    final collector = Collector(
      id: 'collector-${_collectorSequence++}',
      name: draft.name,
      phone: draft.phone,
      area: draft.area,
      status: draft.status,
      customerIds: const [],
    );
    _collectors.add(collector);
    return collector;
  }

  @override
  Collector updateCollector(Collector collector) {
    final index = _collectors.indexWhere((item) => item.id == collector.id);
    if (index == -1) {
      throw ArgumentError('Collector not found: ${collector.id}');
    }
    _collectors[index] = collector;
    return collector;
  }

  @override
  Collector deactivateCollector(String collectorId) {
    final collector = _collectorById(
      collectorId,
    ).copyWith(status: AdminRecordStatus.inactive);
    return updateCollector(collector);
  }

  @override
  void deleteCollector(String collectorId) {
    _collectors.removeWhere((collector) => collector.id == collectorId);
    for (var index = 0; index < _customers.length; index++) {
      final customer = _customers[index];
      if (customer.assignedCollectorId == collectorId) {
        _customers[index] = customer.copyWith(clearAssignedCollector: true);
      }
    }
    _syncCollectorAssignments();
  }

  @override
  Collector assignCustomersToCollector(
    String collectorId,
    List<String> customerIds,
  ) {
    _collectorById(collectorId);
    final selectedIds = customerIds.toSet();
    for (var index = 0; index < _customers.length; index++) {
      final customer = _customers[index];
      if (selectedIds.contains(customer.id)) {
        _customers[index] = customer.copyWith(assignedCollectorId: collectorId);
      } else if (customer.assignedCollectorId == collectorId) {
        _customers[index] = customer.copyWith(clearAssignedCollector: true);
      }
    }
    _syncCollectorAssignments();
    return _collectorById(collectorId);
  }

  Customer _customerById(String customerId) {
    return _customers.firstWhere(
      (customer) => customer.id == customerId,
      orElse: () => throw ArgumentError('Customer not found: $customerId'),
    );
  }

  Collector _collectorById(String collectorId) {
    return _collectors.firstWhere(
      (collector) => collector.id == collectorId,
      orElse: () => throw ArgumentError('Collector not found: $collectorId'),
    );
  }

  void _syncCollectorAssignments() {
    for (var index = 0; index < _collectors.length; index++) {
      final collector = _collectors[index];
      final customerIds = _customers
          .where((customer) => customer.assignedCollectorId == collector.id)
          .map((customer) => customer.id)
          .toList(growable: false);
      _collectors[index] = collector.copyWith(customerIds: customerIds);
    }
  }

  void _seed() {
    if (_customers.isNotEmpty || _collectors.isNotEmpty) {
      return;
    }

    _collectors.addAll(const [
      Collector(
        id: 'collector-nguyen-minh',
        name: 'Nguyen Minh',
        phone: '0917 111 2233',
        area: 'Tuyen A',
        status: AdminRecordStatus.active,
        customerIds: [],
      ),
      Collector(
        id: 'collector-le-huy',
        name: 'Le Huy',
        phone: '0917 444 8899',
        area: 'Tuyen B',
        status: AdminRecordStatus.active,
        customerIds: [],
      ),
    ]);

    _customers.addAll(const [
      Customer(
        id: 'customer-nguyen-thi-lan',
        name: 'Nguyen Thi Lan',
        phone: '0917 555 1234',
        address: 'So 18 Dien Bien Phu',
        meterNumber: 'WM-20841',
        status: AdminRecordStatus.active,
        assignedCollectorId: 'collector-nguyen-minh',
        qrGenerated: true,
      ),
      Customer(
        id: 'customer-nguyen-van-minh',
        name: 'Nguyen Van Minh',
        phone: '0918 222 7788',
        address: '18 Dien Bien Phu, Ward 3',
        meterNumber: 'WM-20842',
        status: AdminRecordStatus.active,
        assignedCollectorId: 'collector-le-huy',
        qrGenerated: false,
      ),
    ]);

    _syncCollectorAssignments();
  }
}
