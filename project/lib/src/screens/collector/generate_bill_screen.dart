import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class GenerateBillScreen extends StatelessWidget {
  const GenerateBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Generate Bill Screen',
      backLabel: 'Record Meter Reading',
      backRoute: AppRoutes.recordMeterReading,
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
                        LabeledValue(label: 'Amount', value: '1.245.000 VND'),
                      ],
                    ),
                    MockGrid(
                      children: [
                        DetailTile(label: 'Previous Reading', value: '982'),
                        DetailTile(label: 'Current Reading', value: '1,024'),
                        DetailTile(label: 'Water Usage', value: '42 m3'),
                        DetailTile(label: 'Rate Per Unit', value: '29,643 VND'),
                        DetailTile(label: 'Due Date', value: '05/06/2026'),
                        DetailTile(
                          label: 'Bill Status',
                          value: 'Pending approval',
                        ),
                      ],
                    ),
                    MockField(
                      label: 'Bill Note',
                      hintText: 'Add an optional bill note',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'Confirm Bill',
                    route: AppRoutes.collectPayment,
                    primary: true,
                  ),
                  MockAction(
                    'Edit Reading',
                    route: AppRoutes.recordMeterReading,
                  ),
                ],
              ),
              ActionBar(
                actions: [
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
