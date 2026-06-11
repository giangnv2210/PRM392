import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class CollectorDashboardScreen extends StatelessWidget {
  const CollectorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Collector Dashboard',
      subtitle:
          'Track assigned customers, daily collections, and open the QR flow to jump straight to a meter record.',
      backLabel: 'Login Screen',
      backRoute: AppRoutes.login,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockGrid(
                children: [
                  MetricTile(
                    title: 'Assigned Customers',
                    value: '48 meters today',
                  ),
                  MetricTile(title: 'Pending Collections', value: '19 bills'),
                  MetricTile(title: 'Collected Today', value: '12,450,000 VND'),
                  MetricTile(title: 'Overdue Alerts', value: '5 accounts'),
                ],
              ),
              HeroPanel(
                child: Stacked(
                  children: [
                    StatusPill('Daily Summary'),
                    MockupCard(
                      child: Stacked(
                        gap: 10,
                        children: [
                          ListRecordTile(
                            title: 'Nguyen Van Minh',
                            subtitle:
                                '18 Dien Bien Phu | Meter 00123456 | Due | 1,245,000 VND',
                            actions: [
                              MockAction(
                                'Open',
                                route: AppRoutes.customerDetails,
                              ),
                            ],
                          ),
                          ListRecordTile(
                            title: 'Tran Thi Hoa',
                            subtitle:
                                '77 Nguyen Trai | Meter 00123457 | Paid | 0 VND',
                            actions: [
                              MockAction(
                                'Open',
                                route: AppRoutes.customerDetails,
                              ),
                            ],
                          ),
                          ListRecordTile(
                            title: 'Le Quoc Huy',
                            subtitle:
                                '04 Tran Phu | Meter 00123458 | Overdue | 1,980,000 VND',
                            actions: [
                              MockAction(
                                'Open',
                                route: AppRoutes.customerDetails,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction('Scan QR', route: AppRoutes.scanQr, primary: true),
                  MockAction(
                    'Customer Details',
                    route: AppRoutes.customerDetails,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'Collection History',
                    route: AppRoutes.collectionHistory,
                  ),
                  MockAction('Settings', route: AppRoutes.collectorSettings),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
