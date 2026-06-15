import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';

class BillingManagementScreen extends StatelessWidget {
  const BillingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
      theme: ScreenThemeVariant.admin,
      title: 'Billing Management Screen',
      backLabel: 'Admin Dashboard',
      backRoute: AppRoutes.adminDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              AppCard(
                child: ResponsiveGrid(
                  children: [
                    AppField(
                      label: 'Search Bill',
                      hintText: 'Search customer, bill ID, or meter no.',
                    ),
                    AppField(
                      label: 'Status',
                      options: [
                        'All',
                        'Paid',
                        'Unpaid',
                        'Overdue',
                        'Pending Approval',
                        'Cancelled',
                      ],
                      dropdownValue: 'All',
                    ),
                  ],
                ),
              ),
              ListRecordTile(
                title: 'Nguyen Thi Lan',
                subtitle: 'Thang 5/2026 | 1.245.000 VND | Da tao',
                extra: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppChip('Usage: 42 m3'),
                      AppChip('Due: 05/06/2026'),
                    ],
                  ),
                ],
                actions: [AppAction('Edit Bill')],
              ),
              ListRecordTile(
                title: 'Pham Quoc Huy',
                subtitle: 'Thang 5/2026 | 1.112.000 VND | Qua han',
                extra: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppChip('Usage: 37 m3'),
                      AppChip('Collector: Le Huy'),
                    ],
                  ),
                ],
                actions: [AppAction('Approve')],
              ),
              ActionBar(actions: [AppAction('Export Bills')]),
            ],
          ),
        ),
      ],
    );
  }
}
