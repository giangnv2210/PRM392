import 'package:flutter/material.dart';

import 'navigation/app_routes.dart';
import 'screens/admin_screens.dart';
import 'screens/auth_screens.dart';
import 'screens/collector_screens.dart';
import 'ui/mockup_widgets.dart';

class WaterBillApp extends StatelessWidget {
  const WaterBillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Bill Collection App',
      theme: buildAppTheme(),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),
        AppRoutes.collectorDashboard: (_) => const CollectorDashboardScreen(),
        AppRoutes.customerDetails: (_) => const CustomerDetailsScreen(),
        AppRoutes.scanQr: (_) => const ScanQrScreen(),
        AppRoutes.viewComplaints: (_) => const ViewComplaintsScreen(),
        AppRoutes.recordMeterReading: (_) => const RecordMeterReadingScreen(),
        AppRoutes.generateBill: (_) => const GenerateBillScreen(),
        AppRoutes.collectPayment: (_) => const CollectPaymentScreen(),
        AppRoutes.collectionHistory: (_) => const CollectionHistoryScreen(),
        AppRoutes.billDetails: (_) => const BillDetailsScreen(),
        AppRoutes.collectorSettings: (_) => const CollectorSettingsScreen(),
        AppRoutes.adminDashboard: (_) => const AdminDashboardScreen(),
        AppRoutes.manageCustomers: (_) => const ManageCustomersScreen(),
        AppRoutes.manageCollectors: (_) => const ManageCollectorsScreen(),
        AppRoutes.billingManagement: (_) => const BillingManagementScreen(),
        AppRoutes.paymentRecords: (_) => const PaymentRecordsScreen(),
        AppRoutes.viewReports: (_) => const ViewReportsScreen(),
        AppRoutes.adminSettings: (_) => const AdminSettingsScreen(),
      },
    );
  }
}
