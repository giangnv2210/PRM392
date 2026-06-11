import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class BillingManagementScreen extends StatelessWidget {
  const BillingManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.admin,
      title: 'Billing Management Screen',
      backLabel: 'Admin Dashboard',
      backRoute: AppRoutes.adminDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockupCard(
                child: MockGrid(
                  children: [
                    MockField(
                      label: 'Search Bill',
                      hintText: 'Search customer, bill ID, or meter no.',
                    ),
                    MockField(
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
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('Usage: 42 m3'),
                      AppChip('Due: 05/06/2026'),
                    ],
                  ),
                ],
                actions: [MockAction('Edit Bill')],
              ),
              ListRecordTile(
                title: 'Pham Quoc Huy',
                subtitle: 'Thang 5/2026 | 1.112.000 VND | Qua han',
                extra: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('Usage: 37 m3'),
                      AppChip('Collector: Le Huy'),
                    ],
                  ),
                ],
                actions: [MockAction('Approve')],
              ),
              ActionBar(actions: [MockAction('Export Bills')]),
            ],
          ),
        ),
      ],
    );
  }
}
