enum ScreenThemeVariant { auth, collector, admin }

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';

  static const collectorDashboard = '/collector-dashboard';
  static const customerDetails = '/customer-details';
  static const scanQr = '/scan-qr';
  static const viewComplaints = '/view-complaints';
  static const recordMeterReading = '/record-meter-reading';
  static const generateBill = '/generate-bill';
  static const collectPayment = '/collect-payment';
  static const collectionHistory = '/collection-history';
  static const billDetails = '/bill-details';
  static const collectorSettings = '/collector-settings';

  static const adminDashboard = '/admin-dashboard';
  static const manageCustomers = '/manage-customers';
  static const manageCollectors = '/manage-collectors';
  static const billingManagement = '/billing-management';
  static const paymentRecords = '/payment-records';
  static const viewReports = '/view-reports';
  static const adminSettings = '/admin-settings';
}
