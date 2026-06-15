import '../models/collector_customer.dart';
import '../models/customer_bill.dart';

abstract interface class CollectorWorkRepository {
  List<CollectorCustomer> assignedCustomers();
  CollectorCustomer selectedCustomer();
  void selectCustomer(String customerId);

  List<CustomerBill> billsForCustomer(String customerId);
  List<CustomerBill> billsForSelectedCustomer();
  CustomerBill selectedBill();
  void selectBill(String billId);

  CustomerBill createBillForSelectedCustomer({
    required String billingPeriod,
    required int currentReading,
    required String dueDate,
    required String readingDate,
    required String meterPhoto,
    required String note,
  });

  CustomerBill updateSelectedBill({
    required String billingPeriod,
    required int currentReading,
    required String dueDate,
    required String readingDate,
    required String meterPhoto,
    required String note,
  });

  void deleteSelectedBill();

  CustomerBill markSelectedBillPaid({
    required String paymentMethod,
    required String note,
  });
}
