import 'bill_status.dart';

class CustomerBill {
  const CustomerBill({
    required this.id,
    required this.customerId,
    required this.billingPeriod,
    required this.previousReading,
    required this.currentReading,
    required this.usageM3,
    required this.amountDue,
    required this.dueDate,
    required this.readingDate,
    required this.meterPhoto,
    required this.status,
    this.paymentMethod,
    this.paidAt,
    this.note,
  });

  final String id;
  final String customerId;
  final String billingPeriod;
  final int previousReading;
  final int currentReading;
  final int usageM3;
  final int amountDue;
  final String dueDate;
  final String readingDate;
  final String meterPhoto;
  final BillStatus status;
  final String? paymentMethod;
  final String? paidAt;
  final String? note;

  String get amountLabel => formatVnd(amountDue);

  CustomerBill copyWith({
    String? id,
    String? customerId,
    String? billingPeriod,
    int? previousReading,
    int? currentReading,
    int? usageM3,
    int? amountDue,
    String? dueDate,
    String? readingDate,
    String? meterPhoto,
    BillStatus? status,
    String? paymentMethod,
    String? paidAt,
    String? note,
  }) {
    return CustomerBill(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      previousReading: previousReading ?? this.previousReading,
      currentReading: currentReading ?? this.currentReading,
      usageM3: usageM3 ?? this.usageM3,
      amountDue: amountDue ?? this.amountDue,
      dueDate: dueDate ?? this.dueDate,
      readingDate: readingDate ?? this.readingDate,
      meterPhoto: meterPhoto ?? this.meterPhoto,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAt: paidAt ?? this.paidAt,
      note: note ?? this.note,
    );
  }
}

String formatVnd(int amount) {
  final raw = amount.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < raw.length; index++) {
    final remaining = raw.length - index;
    buffer.write(raw[index]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return '$buffer VND';
}
