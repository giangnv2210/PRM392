import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Customer Details Screen',
      subtitle:
          'Review the scanned meter account, current bill state, and jump into the next collector actions.',
      backLabel: 'Scan QR',
      backRoute: AppRoutes.scanQr,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              HeroPanel(
                child: Stacked(
                  children: [
                    Text(
                      'Nguyen Van Minh',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Phone: 0918 222 7788',
                      style: TextStyle(fontSize: 13, color: Color(0xFF5F6B7A)),
                    ),
                    Text(
                      'Address: 18 Dien Bien Phu, Ward 3',
                      style: TextStyle(fontSize: 13, color: Color(0xFF5F6B7A)),
                    ),
                    Text(
                      'Meter Number: 00123456',
                      style: TextStyle(fontSize: 13, color: Color(0xFF5F6B7A)),
                    ),
                    Text(
                      'QR / Meter Token: MTR-00123456-WB',
                      style: TextStyle(fontSize: 13, color: Color(0xFF5F6B7A)),
                    ),
                    StatusPill('Current Bill Status: Unpaid'),
                  ],
                ),
              ),
              MockupCard(
                child: Stacked(
                  children: [
                    Text(
                      'Customer notes',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Access gate code 2418. Customer prefers evening collection visits and requests receipt confirmation by SMS after payment.',
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
                  MockAction(
                    'Record Meter Reading',
                    route: AppRoutes.recordMeterReading,
                    primary: true,
                  ),
                  MockAction(
                    'Collect Payment',
                    route: AppRoutes.collectPayment,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'View Complaints',
                    route: AppRoutes.viewComplaints,
                  ),
                  MockAction(
                    'Collection History',
                    route: AppRoutes.collectionHistory,
                  ),
                ],
              ),
              ActionBar(actions: [MockAction('Call Customer')]),
            ],
          ),
        ),
      ],
    );
  }
}
