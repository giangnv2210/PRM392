import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class ViewReportsScreen extends StatelessWidget {
  const ViewReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.admin,
      title: 'View Reports Screen',
      backLabel: 'Admin Dashboard',
      backRoute: AppRoutes.adminDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockupCard(
                child: Stacked(
                  children: [
                    MockGrid(
                      children: [
                        MockField(
                          label: 'Report Type',
                          options: [
                            'Revenue',
                            'Unpaid Bills',
                            'Overdue Bills',
                            'Water Usage',
                            'Collector Performance',
                          ],
                          dropdownValue: 'Revenue',
                        ),
                        MockField(
                          label: 'Date Range',
                          hintText: '01/05/2026 - 31/05/2026',
                        ),
                      ],
                    ),
                    MockGrid(
                      children: [
                        MockField(
                          label: 'Area Filter',
                          options: ['All Areas', 'Ward 1', 'Ward 2', 'Ward 3'],
                          dropdownValue: 'All Areas',
                        ),
                        MockField(
                          label: 'Collector Filter',
                          options: ['All Collectors', 'Nguyen Minh', 'Le Huy'],
                          dropdownValue: 'All Collectors',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MockGrid(
                children: [
                  MetricTile(title: 'Unpaid Bills', value: '287'),
                  MetricTile(title: 'Overdue Bills', value: '59'),
                  MetricTile(title: 'Collection Rate', value: '94%'),
                  MetricTile(title: 'Collector Avg.', value: '18 luot'),
                ],
              ),
              MockupCard(
                accent: true,
                child: Stacked(
                  children: [
                    Text(
                      'Report Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Ward 3 generated 684,000,000 VND in May 2026, with 42 overdue accounts and top collector completion from Nguyen Minh at 96%.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F6B7A),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              MockupCard(
                child: Stacked(
                  children: [
                    Text(
                      'Report Table',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    ListRecordTile(
                      title: 'Ward 3',
                      subtitle:
                          'Revenue 684,000,000 VND | Overdue 42 | Usage 15,420 m3',
                    ),
                    ListRecordTile(
                      title: 'Ward 2',
                      subtitle:
                          'Revenue 592,000,000 VND | Overdue 31 | Usage 13,910 m3',
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction('Export Report'),
                  MockAction('Print Summary', primary: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
