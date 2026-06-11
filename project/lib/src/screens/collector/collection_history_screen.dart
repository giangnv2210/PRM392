import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class CollectionHistoryScreen extends StatelessWidget {
  const CollectionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Collection History Screen',
      backLabel: 'Customer Details',
      backRoute: AppRoutes.customerDetails,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockupCard(
                child: MockGrid(
                  children: [
                    MockField(
                      label: 'Date Filter',
                      hintText: '01/05/2026 - 31/05/2026',
                    ),
                    MockField(
                      label: 'Status Filter',
                      options: [
                        'All',
                        'Paid',
                        'Unpaid',
                        'Overdue',
                        'Cancelled',
                      ],
                      dropdownValue: 'All',
                    ),
                  ],
                ),
              ),
              ListRecordTile(
                title: 'May 2026',
                subtitle: 'Nguyen Van Minh | Cash | 1,245,000 VND | 23/05/2026',
                actions: [
                  MockAction('View Detail', route: AppRoutes.billDetails),
                ],
              ),
              ListRecordTile(
                title: 'May 2026',
                subtitle:
                    'Tran Thi Hoa | Bank Transfer | 910,000 VND | 22/05/2026',
                actions: [
                  MockAction('View Detail', route: AppRoutes.billDetails),
                ],
              ),
              ListRecordTile(
                title: 'April 2026',
                subtitle: 'Le Quoc Huy | Cash | 1,050,000 VND | 20/05/2026',
                actions: [
                  MockAction('View Detail', route: AppRoutes.billDetails),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
