enum BillStatus {
  unpaid('Unpaid'),
  overdue('Overdue'),
  paid('Paid');

  const BillStatus(this.label);

  final String label;

  bool get canProceedToPayment => this != BillStatus.paid;
}
