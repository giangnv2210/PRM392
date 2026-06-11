import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class PaymentRecordsScreen extends StatelessWidget {
  const PaymentRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.admin,
      title: 'Payment Records Screen',
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
                      label: 'Search Payment',
                      hintText: 'Search customer, receipt, bill, or collector',
                    ),
                    MockField(
                      label: 'Method',
                      options: [
                        'All',
                        'Cash',
                        'GCash',
                        'Bank Transfer',
                        'Card',
                      ],
                      dropdownValue: 'All',
                    ),
                  ],
                ),
              ),
              ListRecordTile(
                title: 'Nguyen Thi Lan',
                subtitle:
                    'Bank transfer | 1.245.000 VND | Thu boi: Nguyen Minh',
                extra: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('Status: Successful'),
                      AppChip('23/05/2026 10:42 AM'),
                    ],
                  ),
                ],
                actions: [MockAction('Open Record')],
              ),
              ListRecordTile(
                title: 'Pham Quoc Huy',
                subtitle: 'Cash | 1.112.000 VND | Thu boi: Le Huy',
                extra: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppChip('Status: Pending'),
                      AppChip('22/05/2026 03:12 PM'),
                    ],
                  ),
                ],
                actions: [MockAction('Open Record')],
              ),
              ActionBar(actions: [MockAction('Export Records')]),
            ],
          ),
        ),
      ],
    );
  }
}
