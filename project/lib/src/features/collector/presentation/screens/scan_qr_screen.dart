import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
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
              AppCard(
                accent: true,
                child: Stacked(
                  children: [
                    ResponsiveGrid(
                      children: [
                        Stacked(
                          gap: 10,
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
                          gap: 10,
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
                    AppField(
                      label: 'Manual Meter Code',
                      hintText: 'Enter meter code if QR cannot be read',
                      initialValue: '00123456',
                    ),
                    ActionBar(
                      actions: [
                        AppAction('Flash Toggle'),
                        AppAction('Retry Scan', route: AppRoutes.scanQr),
                      ],
                    ),
                    ActionBar(
                      actions: [
                        AppAction(
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
