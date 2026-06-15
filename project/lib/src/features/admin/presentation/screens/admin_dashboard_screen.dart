import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
      theme: ScreenThemeVariant.admin,
      title: 'Admin Dashboard',
      showHeader: true,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              ResponsiveGrid(
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
                  AppAction(
                    'Manage Customers',
                    route: AppRoutes.manageCustomers,
                    primary: true,
                  ),
                  AppAction(
                    'Manage Collectors',
                    route: AppRoutes.manageCollectors,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  AppAction(
                    'Billing Management',
                    route: AppRoutes.billingManagement,
                  ),
                  AppAction('Payment Records', route: AppRoutes.paymentRecords),
                ],
              ),
              ActionBar(
                actions: [
                  AppAction('View Reports', route: AppRoutes.viewReports),
                  AppAction('Admin Settings', route: AppRoutes.adminSettings),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
