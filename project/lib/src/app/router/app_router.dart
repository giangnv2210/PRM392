import '../../features/admin/admin.dart';
import '../../features/auth/auth.dart';
import '../../features/collector/collector.dart';
import 'app_routes.dart';

abstract final class AppRouter {
  static const initialRoute = AppRoutes.login;

  static final routes = {
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),
    AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),
    AppRoutes.collectorDashboard: (_) => const CollectorDashboardScreen(),
    AppRoutes.assignedCustomers: (_) => const AssignedCustomersScreen(),
    AppRoutes.customerDetails: (_) => const CustomerDetailsScreen(),
    AppRoutes.customerBills: (_) => const CustomerBillsScreen(),
    AppRoutes.newBill: (_) => const NewBillScreen(),
    AppRoutes.scanQr: (_) => const ScanQrScreen(),
    AppRoutes.viewComplaints: (_) => const ViewComplaintsScreen(),
    AppRoutes.collectPayment: (_) => const CollectPaymentScreen(),
    AppRoutes.billDetails: (_) => const BillDetailsScreen(),
    AppRoutes.collectorSettings: (_) => const CollectorSettingsScreen(),
    AppRoutes.adminDashboard: (_) => const AdminDashboardScreen(),
    AppRoutes.manageCustomers: (_) => const ManageCustomersScreen(),
    AppRoutes.manageCollectors: (_) => const ManageCollectorsScreen(),
    AppRoutes.billingManagement: (_) => const BillingManagementScreen(),
    AppRoutes.paymentRecords: (_) => const PaymentRecordsScreen(),
    AppRoutes.viewReports: (_) => const ViewReportsScreen(),
    AppRoutes.adminSettings: (_) => const AdminSettingsScreen(),
  };
}
