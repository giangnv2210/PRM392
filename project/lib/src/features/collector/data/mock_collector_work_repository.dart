import '../domain/models/bill_status.dart';
import '../domain/models/collector_customer.dart';
import '../domain/models/customer_bill.dart';
import '../domain/repositories/collector_work_repository.dart';

class MockCollectorWorkRepository implements CollectorWorkRepository {
  MockCollectorWorkRepository._();

  static final MockCollectorWorkRepository instance =
      MockCollectorWorkRepository._().._seed();

  final List<CollectorCustomer> _customers = [];
  final List<CustomerBill> _bills = [];
  String? _selectedCustomerId;
  String? _selectedBillId;
  int _billSequence = 300;

  @override
  List<CollectorCustomer> assignedCustomers() => List.unmodifiable(_customers);

  @override
  CollectorCustomer selectedCustomer() {
    final id = _selectedCustomerId ?? _customers.first.id;
    return _customers.firstWhere((customer) => customer.id == id);
  }

  @override
  void selectCustomer(String customerId) {
    _customers.firstWhere((customer) => customer.id == customerId);
    _selectedCustomerId = customerId;
    final bills = _billsForCustomer(customerId);
    _selectedBillId = bills.isEmpty ? null : bills.first.id;
  }

  @override
  List<CustomerBill> billsForCustomer(String customerId) {
    return List.unmodifiable(_billsForCustomer(customerId));
  }

  @override
  List<CustomerBill> billsForSelectedCustomer() {
    return List.unmodifiable(_billsForCustomer(selectedCustomer().id));
  }

  @override
  CustomerBill selectedBill() {
    final bills = billsForSelectedCustomer();
    final id = _selectedBillId ?? bills.first.id;
    return bills.firstWhere((bill) => bill.id == id);
  }

  @override
  void selectBill(String billId) {
    final bill = _bills.firstWhere((item) => item.id == billId);
    _selectedCustomerId = bill.customerId;
    _selectedBillId = bill.id;
  }

  @override
  CustomerBill createBillForSelectedCustomer({
    required String billingPeriod,
    required int currentReading,
    required String dueDate,
    required String readingDate,
    required String meterPhoto,
    required String note,
  }) {
    final customer = selectedCustomer();
    final previousReading = _lastReadingForCustomer(customer.id);
    final usage = (currentReading - previousReading).clamp(0, 999999);
    final bill = CustomerBill(
      id: 'WB-2026-${_billSequence++}',
      customerId: customer.id,
      billingPeriod: billingPeriod,
      previousReading: previousReading,
      currentReading: currentReading,
      usageM3: usage,
      amountDue: usage * 30000,
      dueDate: dueDate,
      readingDate: readingDate,
      meterPhoto: meterPhoto,
      status: BillStatus.unpaid,
      note: note.trim().isEmpty ? null : note.trim(),
    );
    _bills.insert(0, bill);
    _selectedBillId = bill.id;
    return bill;
  }

  @override
  CustomerBill updateSelectedBill({
    required String billingPeriod,
    required int currentReading,
    required String dueDate,
    required String readingDate,
    required String meterPhoto,
    required String note,
  }) {
    final bill = selectedBill();
    if (!bill.status.canProceedToPayment) {
      throw StateError('Paid bills cannot be edited.');
    }

    final index = _bills.indexWhere((item) => item.id == bill.id);
    final usage = (currentReading - bill.previousReading).clamp(0, 999999);
    final updatedBill = bill.copyWith(
      billingPeriod: billingPeriod,
      currentReading: currentReading,
      usageM3: usage,
      amountDue: usage * 30000,
      dueDate: dueDate,
      readingDate: readingDate,
      meterPhoto: meterPhoto,
      note: note.trim().isEmpty ? bill.note : note.trim(),
    );
    _bills[index] = updatedBill;
    return updatedBill;
  }

  @override
  void deleteSelectedBill() {
    final bill = selectedBill();
    if (!bill.status.canProceedToPayment) {
      throw StateError('Paid bills cannot be deleted.');
    }

    _bills.removeWhere((item) => item.id == bill.id);
    final remainingBills = _billsForCustomer(bill.customerId);
    _selectedBillId = remainingBills.isEmpty ? null : remainingBills.first.id;
  }

  @override
  CustomerBill markSelectedBillPaid({
    required String paymentMethod,
    required String note,
  }) {
    final bill = selectedBill();
    final index = _bills.indexWhere((item) => item.id == bill.id);
    final paidBill = bill.copyWith(
      status: BillStatus.paid,
      paymentMethod: paymentMethod,
      paidAt: 'Today',
      note: note.trim().isEmpty ? bill.note : note.trim(),
    );
    _bills[index] = paidBill;
    return paidBill;
  }

  List<CustomerBill> _billsForCustomer(String customerId) {
    return _bills.where((bill) => bill.customerId == customerId).toList();
  }

  int _lastReadingForCustomer(String customerId) {
    final bills = _billsForCustomer(customerId);
    if (bills.isEmpty) {
      return 0;
    }
    return bills
        .map((bill) => bill.currentReading)
        .reduce((value, current) => value > current ? value : current);
  }

  void _seed() {
    if (_customers.isNotEmpty) {
      return;
    }

    _customers.addAll(const [
      CollectorCustomer(
        id: 'customer-nguyen-van-minh',
        name: 'Nguyen Van Minh',
        phone: '0918 222 7788',
        address: '18 Dien Bien Phu, Ward 3',
        meterNumber: 'WM-20842',
        meterToken: 'MTR-WM-20842-WB',
        notes:
            'Access gate code 2418. Customer prefers evening visits and SMS receipt confirmation.',
      ),
      CollectorCustomer(
        id: 'customer-nguyen-thi-lan',
        name: 'Nguyen Thi Lan',
        phone: '0917 555 1234',
        address: 'So 18 Dien Bien Phu',
        meterNumber: 'WM-20841',
        meterToken: 'MTR-WM-20841-WB',
        notes: 'Collect before 11 AM. Usually pays by cash.',
      ),
      CollectorCustomer(
        id: 'customer-tran-thi-hoa',
        name: 'Tran Thi Hoa',
        phone: '0903 332 441',
        address: '77 Nguyen Trai',
        meterNumber: 'WM-20843',
        meterToken: 'MTR-WM-20843-WB',
        notes: 'Apartment reception can confirm access if customer is away.',
      ),
    ]);

    _bills.addAll(const [
      CustomerBill(
        id: 'WB-2026-05-1842',
        customerId: 'customer-nguyen-van-minh',
        billingPeriod: 'May 2026',
        previousReading: 982,
        currentReading: 1024,
        usageM3: 42,
        amountDue: 1245000,
        dueDate: '05/06/2026',
        readingDate: '23/05/2026 10:42 AM',
        meterPhoto: 'meter-WM-20842-may.jpg',
        status: BillStatus.unpaid,
      ),
      CustomerBill(
        id: 'WB-2026-04-1842',
        customerId: 'customer-nguyen-van-minh',
        billingPeriod: 'April 2026',
        previousReading: 930,
        currentReading: 982,
        usageM3: 52,
        amountDue: 1050000,
        dueDate: '05/05/2026',
        readingDate: '20/04/2026 09:20 AM',
        meterPhoto: 'meter-WM-20842-apr.jpg',
        status: BillStatus.paid,
        paymentMethod: 'Cash',
        paidAt: '20/05/2026',
      ),
      CustomerBill(
        id: 'WB-2026-05-1841',
        customerId: 'customer-nguyen-thi-lan',
        billingPeriod: 'May 2026',
        previousReading: 1462,
        currentReading: 1518,
        usageM3: 56,
        amountDue: 1680000,
        dueDate: '05/06/2026',
        readingDate: '23/05/2026 08:15 AM',
        meterPhoto: 'meter-WM-20841-may.jpg',
        status: BillStatus.overdue,
      ),
      CustomerBill(
        id: 'WB-2026-05-1843',
        customerId: 'customer-tran-thi-hoa',
        billingPeriod: 'May 2026',
        previousReading: 780,
        currentReading: 811,
        usageM3: 31,
        amountDue: 930000,
        dueDate: '05/06/2026',
        readingDate: '22/05/2026 03:12 PM',
        meterPhoto: 'meter-WM-20843-may.jpg',
        status: BillStatus.paid,
        paymentMethod: 'Bank Transfer',
        paidAt: '22/05/2026',
      ),
    ]);

    _selectedCustomerId = _customers.first.id;
    _selectedBillId = _bills.first.id;
  }
}
