import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Bill Details Screen',
      subtitle:
          'Review readings, charges, and payment status for a selected collection record.',
      backLabel: 'Collection History',
      backRoute: AppRoutes.collectionHistory,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              HeroPanel(
                child: Stacked(
                  children: [
                    MockGrid(
                      children: [
                        LabeledValue(
                          label: 'Bill ID',
                          value: 'WB-2026-05-1842',
                        ),
                        Stacked(
                          gap: 6,
                          children: [
                            Text(
                              'Payment Status',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            StatusPill('Paid'),
                          ],
                        ),
                      ],
                    ),
                    MockGrid(
                      children: [
                        LabeledValue(label: 'Billing Month', value: 'May 2026'),
                        LabeledValue(
                          label: 'Customer Name',
                          value: 'Nguyen Van Minh',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MockGrid(
                children: [
                  DetailTile(label: 'Meter Number', value: '00123456'),
                  DetailTile(label: 'Previous Reading', value: '1,462'),
                  DetailTile(label: 'Current Reading', value: '1,518'),
                  DetailTile(label: 'Water Usage', value: '56 m3'),
                  DetailTile(label: 'Total Amount', value: '1,245,000 VND'),
                  DetailTile(label: 'Receipt', value: 'RCPT-42881'),
                ],
              ),
              MockupCard(
                child: Stacked(
                  gap: 4,
                  children: [
                    Text(
                      'Payment Information',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Collected in cash on 23/05/2026 at 10:42 AM by Le Quoc Huy. Receipt information is available after payment confirmation.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F6B7A),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction('View Receipt', primary: true),
                  MockAction('Back', route: AppRoutes.collectionHistory),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
