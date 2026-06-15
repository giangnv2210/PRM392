import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_collector_work_repository.dart';

class NewBillScreen extends StatefulWidget {
  const NewBillScreen({super.key});

  @override
  State<NewBillScreen> createState() => _NewBillScreenState();
}

class _NewBillScreenState extends State<NewBillScreen> {
  final _repository = MockCollectorWorkRepository.instance;
  final _billingPeriodController = TextEditingController();
  final _readingController = TextEditingController();
  final _readingDateController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _meterPhotoController = TextEditingController();
  final _noteController = TextEditingController();

  int get _previousReading {
    final bills = _repository.billsForSelectedCustomer();
    if (bills.isEmpty) {
      return 0;
    }
    return bills
        .map((bill) => bill.currentReading)
        .reduce((value, current) => value > current ? value : current);
  }

  @override
  void initState() {
    super.initState();
    _billingPeriodController.text = 'June 2026';
    _readingController.text = '${_previousReading + 1}';
    _readingDateController.text = 'Today';
    _dueDateController.text = '05/07/2026';
    _meterPhotoController.text = 'meter-photo-placeholder.jpg';
  }

  @override
  void dispose() {
    _billingPeriodController.dispose();
    _readingController.dispose();
    _readingDateController.dispose();
    _dueDateController.dispose();
    _meterPhotoController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _createBill() {
    final currentReading = int.tryParse(_readingController.text.trim());
    if (currentReading == null) {
      showAppMessage(context, 'Enter a valid meter reading.');
      return;
    }
    if (currentReading < _previousReading) {
      showAppMessage(
        context,
        'Current reading cannot be lower than previous reading.',
      );
      return;
    }
    final billingPeriod = _billingPeriodController.text.trim();
    final dueDate = _dueDateController.text.trim();
    final readingDate = _readingDateController.text.trim();
    final meterPhoto = _meterPhotoController.text.trim();
    if ([billingPeriod, dueDate, readingDate, meterPhoto].any((value) {
      return value.isEmpty;
    })) {
      showAppMessage(context, 'Complete all meter reading and bill fields.');
      return;
    }

    final bill = _repository.createBillForSelectedCustomer(
      billingPeriod: billingPeriod,
      currentReading: currentReading,
      dueDate: dueDate,
      readingDate: readingDate,
      meterPhoto: meterPhoto,
      note: _noteController.text,
    );
    showAppMessage(context, '${bill.id} created as unpaid.');
    openAppRoute(context, AppRoutes.customerBills, replaceRoute: true);
  }

  @override
  Widget build(BuildContext context) {
    final customer = _repository.selectedCustomer();
    final previousReading = _previousReading;

    return AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'New Bill Screen',
      backLabel: 'Customer Bills',
      backRoute: AppRoutes.customerBills,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              SectionHeader(
                title: 'Record meter reading',
                subtitle: '${customer.name} | ${customer.meterNumber}',
              ),
              AppCard(
                accent: true,
                child: Stacked(
                  children: [
                    ResponsiveGrid(
                      children: [
                        LabeledValue(
                          label: 'Previous Reading',
                          value: '$previousReading m3',
                        ),
                        LabeledValue(label: 'Rate', value: '30.000 VND / m3'),
                      ],
                    ),
                    AppField(
                      label: 'Billing Period',
                      hintText: 'Month and year',
                      controller: _billingPeriodController,
                    ),
                    AppField(
                      label: 'Current Reading',
                      hintText: 'Enter current meter reading',
                      controller: _readingController,
                      keyboardType: TextInputType.number,
                    ),
                    ResponsiveGrid(
                      children: [
                        AppField(
                          label: 'Reading Date',
                          hintText: 'Enter reading date',
                          controller: _readingDateController,
                        ),
                        AppField(
                          label: 'Due Date',
                          hintText: 'Enter bill due date',
                          controller: _dueDateController,
                        ),
                      ],
                    ),
                    AppField(
                      label: 'Meter Photo',
                      hintText: 'Attach or enter photo filename',
                      controller: _meterPhotoController,
                    ),
                    AppField(
                      label: 'Bill Note',
                      hintText: 'Optional reading or billing note',
                      controller: _noteController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  AppAction('Cancel', route: AppRoutes.customerBills),
                  AppAction(
                    'Create Bill',
                    primary: true,
                    onPressed: _createBill,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
