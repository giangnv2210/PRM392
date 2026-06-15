import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';

class PaymentRecordsScreen extends StatelessWidget {
  const PaymentRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
      theme: ScreenThemeVariant.admin,
      title: 'Payment Records Screen',
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
                      label: 'Search Payment',
                      hintText: 'Search customer, receipt, bill, or collector',
                    ),
                    AppField(
                      label: 'Method',
                      options: ['All', 'Cash', 'Bank Transfer'],
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
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppChip('Status: Successful'),
                      AppChip('23/05/2026 10:42 AM'),
                    ],
                  ),
                ],
                actions: [AppAction('Open Record')],
              ),
              ListRecordTile(
                title: 'Pham Quoc Huy',
                subtitle: 'Cash | 1.112.000 VND | Thu boi: Le Huy',
                extra: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppChip('Status: Pending'),
                      AppChip('22/05/2026 03:12 PM'),
                    ],
                  ),
                ],
                actions: [AppAction('Open Record')],
              ),
              ActionBar(actions: [AppAction('Export Records')]),
            ],
          ),
        ),
      ],
    );
  }
}
