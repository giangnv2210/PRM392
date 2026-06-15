import '../models/collector.dart';
import '../models/customer.dart';

abstract interface class AdminRepository {
  List<Customer> listCustomers();
  List<Collector> listCollectors();

  Customer createCustomer(CustomerDraft draft);
  Customer updateCustomer(Customer customer);
  Customer deactivateCustomer(String customerId);
  void deleteCustomer(String customerId);
  Customer assignCollectorToCustomer(String customerId, String? collectorId);
  Customer setCustomerQrGenerated(String customerId, bool qrGenerated);

  Collector createCollector(CollectorDraft draft);
  Collector updateCollector(Collector collector);
  Collector deactivateCollector(String collectorId);
  void deleteCollector(String collectorId);
  Collector assignCustomersToCollector(
    String collectorId,
    List<String> customerIds,
  );
}
