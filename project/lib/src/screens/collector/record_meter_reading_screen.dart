import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class RecordMeterReadingScreen extends StatelessWidget {
  const RecordMeterReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Record Meter Reading Screen',
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
                        LabeledValue(label: 'Meter No.', value: 'WM-20841'),
                      ],
                    ),
                    MockGrid(
                      children: [
                        LabeledValue(
                          label: 'Previous Reading',
                          value: '982 m3',
                        ),
                        LabeledValue(
                          label: 'Current Reading',
                          value: '1.024 m3',
                        ),
                      ],
                    ),
                    MockField(
                      label: 'New Reading',
                      hintText: 'Enter current meter reading',
                    ),
                    MockField(
                      label: 'Reading Date',
                      initialValue: '23/05/2026 10:42 AM',
                    ),
                    MockField(
                      label: 'Meter Photo',
                      initialValue: 'meter-00123456.jpg',
                    ),
                    MockField(
                      label: 'Reading Note',
                      hintText: 'Optional note about the reading',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'Continue',
                    route: AppRoutes.generateBill,
                    primary: true,
                  ),
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
