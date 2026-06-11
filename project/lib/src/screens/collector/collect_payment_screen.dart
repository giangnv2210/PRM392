import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class CollectPaymentScreen extends StatelessWidget {
  const CollectPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Collect Payment Screen',
      backLabel: 'Customer Details',
      backRoute: AppRoutes.customerDetails,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockupCard(
                accent: true,
                child: Stacked(
                  children: [
                    MockGrid(
                      children: [
                        LabeledValue(
                          label: 'Customer',
                          value: 'Nguyen Van Minh',
                        ),
                        LabeledValue(
                          label: 'Bill ID',
                          value: 'WB-2026-05-1842',
                        ),
                      ],
                    ),
                    MockGrid(
                      children: [
                        LabeledValue(
                          label: 'Amount Due',
                          value: '1.245.000 VND',
                        ),
                        LabeledValue(
                          label: 'Collection Date',
                          value: '23/05/2026 10:42 AM',
                        ),
                      ],
                    ),
                    MockGrid(
                      children: [
                        MockField(
                          label: 'Collected Amount',
                          hintText: 'Enter amount',
                        ),
                        MockField(
                          label: 'Payment Method',
                          options: ['Cash', 'GCash', 'Bank Transfer', 'Card'],
                          dropdownValue: 'Cash',
                        ),
                      ],
                    ),
                    MockField(
                      label: 'Payment Note',
                      hintText: 'Optional note',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction('Confirm Collection', primary: true),
                  MockAction('Cancel', route: AppRoutes.customerDetails),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
