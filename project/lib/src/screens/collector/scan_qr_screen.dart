import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Scan QR Screen',
      subtitle:
          'Scan the QR code attached to the meter, or enter the meter code manually if the label is unreadable.',
      backLabel: 'Collector Dashboard',
      backRoute: AppRoutes.collectorDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              CameraPreviewCard(),
              MockupCard(
                accent: true,
                child: Stacked(
                  children: [
                    MockGrid(
                      children: [
                        Stacked(
                          gap: 6,
                          children: [
                            Text(
                              'Scan Status',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            StatusPill('Scanning'),
                          ],
                        ),
                        Stacked(
                          gap: 6,
                          children: [
                            Text(
                              'QR Code Data',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            AppChip('MTR-00123456-WB'),
                          ],
                        ),
                      ],
                    ),
                    MockField(
                      label: 'Manual Meter Code',
                      hintText: 'Enter meter code if QR cannot be read',
                      initialValue: '00123456',
                    ),
                    ActionBar(
                      actions: [
                        MockAction('Flash Toggle'),
                        MockAction('Retry Scan', route: AppRoutes.scanQr),
                      ],
                    ),
                    ActionBar(
                      actions: [
                        MockAction(
                          'Open Customer Details',
                          route: AppRoutes.customerDetails,
                          primary: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
