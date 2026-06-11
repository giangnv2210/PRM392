import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class ManageCollectorsScreen extends StatelessWidget {
  const ManageCollectorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.admin,
      title: 'Manage Collectors Screen',
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
                      label: 'Search Collector',
                      hintText: 'Search by name, phone, or area',
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
                title: 'Nguyen Minh',
                subtitle: '0917 111 2233 | Tuyen A | 18 khach hang',
                extra: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('Performance: 94%'),
                      AppChip('Status: Active'),
                    ],
                  ),
                ],
                actions: [MockAction('Edit'), MockAction('Assign Customers')],
              ),
              ListRecordTile(
                title: 'Le Huy',
                subtitle: '0917 444 8899 | Tuyen B | 22 khach hang',
                extra: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('Performance: 91%'),
                      AppChip('Status: Active'),
                    ],
                  ),
                ],
                actions: [MockAction('Edit'), MockAction('Reassign Customers')],
              ),
              ActionBar(
                actions: [
                  MockAction('Add Collector', primary: true),
                  MockAction('Assign Customers'),
                ],
              ),
              ActionBar(actions: [MockAction('Deactivate Collector')]),
            ],
          ),
        ),
      ],
    );
  }
}
