import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.admin,
      title: 'Admin Dashboard',
      backLabel: 'Login Screen',
      backRoute: AppRoutes.login,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockGrid(
                children: [
                  MetricTile(title: 'Total Customers', value: '2,184'),
                  MetricTile(title: 'Total Collectors', value: '26'),
                  MetricTile(title: 'Total Bills', value: '3,402'),
                  MetricTile(title: 'Total Revenue', value: '2.84B VND'),
                  MetricTile(title: 'Unpaid Bills', value: '287'),
                  MetricTile(title: 'Overdue Bills', value: '59'),
                ],
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'Manage Customers',
                    route: AppRoutes.manageCustomers,
                    primary: true,
                  ),
                  MockAction(
                    'Manage Collectors',
                    route: AppRoutes.manageCollectors,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'Billing Management',
                    route: AppRoutes.billingManagement,
                  ),
                  MockAction(
                    'Payment Records',
                    route: AppRoutes.paymentRecords,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  MockAction('View Reports', route: AppRoutes.viewReports),
                  MockAction('Admin Settings', route: AppRoutes.adminSettings),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
