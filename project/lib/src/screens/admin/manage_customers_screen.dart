import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class ManageCustomersScreen extends StatelessWidget {
  const ManageCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.admin,
      title: 'Manage Customers Screen',
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
                      label: 'Search Customer',
                      hintText: 'Search by name, phone, address, or meter',
                    ),
                    MockField(
                      label: 'Status Filter',
                      options: ['All', 'Active', 'Inactive'],
                      dropdownValue: 'All',
                    ),
                  ],
                ),
              ),
              ListRecordTile(
                title: 'Nguyen Thi Lan',
                subtitle:
                    '0917 555 1234 | So 18 Dien Bien Phu | Meter WM-20841',
                extra: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('QR: Generated'),
                      AppChip('Collector: Nguyen Minh'),
                    ],
                  ),
                ],
                actions: [
                  MockAction('Edit'),
                  MockAction('Generate QR'),
                  MockAction('Print QR'),
                ],
              ),
              ListRecordTile(
                title: 'Nguyen Van Minh',
                subtitle:
                    '1.245.000 VND open balance | 23/05/2026 | Meter WM-20842',
                extra: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('QR: Not Generated'),
                      AppChip('Collector: Le Huy'),
                    ],
                  ),
                ],
                actions: [
                  MockAction('Edit'),
                  MockAction('Assign Collector'),
                  MockAction('Download QR'),
                ],
              ),
              ActionBar(
                actions: [
                  MockAction('Add Customer', primary: true),
                  MockAction('Assign Collector'),
                ],
              ),
              ActionBar(actions: [MockAction('Deactivate Customer')]),
            ],
          ),
        ),
      ],
    );
  }
}
