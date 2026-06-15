import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_collector_work_repository.dart';

class CollectPaymentScreen extends StatefulWidget {
  const CollectPaymentScreen({super.key});

  @override
  State<CollectPaymentScreen> createState() => _CollectPaymentScreenState();
}

class _CollectPaymentScreenState extends State<CollectPaymentScreen> {
  final _repository = MockCollectorWorkRepository.instance;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  var _paymentMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    _amountController.text = _repository.selectedBill().amountLabel;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _confirmPayment() {
    _repository.markSelectedBillPaid(
      paymentMethod: _paymentMethod,
      note: _noteController.text,
    );
    showAppMessage(context, 'Payment collected.');
    openAppRoute(context, AppRoutes.customerBills, replaceRoute: true);
  }

  @override
  Widget build(BuildContext context) {
    final customer = _repository.selectedCustomer();
    final bill = _repository.selectedBill();

    return AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'Collect Payment Screen',
      backLabel: 'Customer Bills',
      backRoute: AppRoutes.customerBills,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              AppCard(
                accent: true,
                child: Stacked(
                  children: [
                    ResponsiveGrid(
                      children: [
                        LabeledValue(label: 'Customer', value: customer.name),
                        LabeledValue(label: 'Bill ID', value: bill.id),
                      ],
                    ),
                    ResponsiveGrid(
                      children: [
                        LabeledValue(
                          label: 'Amount Due',
                          value: bill.amountLabel,
                        ),
                        LabeledValue(label: 'Status', value: bill.status.label),
                      ],
                    ),
                    ResponsiveGrid(
                      children: [
                        AppField(
                          label: 'Collected Amount',
                          controller: _amountController,
                        ),
                        AppField(
                          label: 'Payment Method',
                          options: const ['Cash', 'Bank Transfer'],
                          dropdownValue: _paymentMethod,
                          onDropdownChanged: (value) {
                            setState(() => _paymentMethod = value ?? 'Cash');
                          },
                        ),
                      ],
                    ),
                    if (_paymentMethod == 'Bank Transfer')
                      _BankPaymentPlaceholder(amountDue: bill.amountLabel),
                    AppField(
                      label: 'Payment Note',
                      hintText: 'Optional note',
                      controller: _noteController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  AppAction(
                    'Confirm Collection',
                    primary: true,
                    onPressed: _confirmPayment,
                  ),
                  AppAction('Cancel', route: AppRoutes.customerBills),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BankPaymentPlaceholder extends StatelessWidget {
  const _BankPaymentPlaceholder({required this.amountDue});

  final String amountDue;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: ResponsiveGrid(
        children: [
          const Stacked(
            gap: 10,
            children: [
              Text(
                'Bank transfer',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              LabeledValue(label: 'Bank', value: 'Demo Bank Vietnam'),
              LabeledValue(label: 'Account Name', value: 'WATER BILL SERVICE'),
              LabeledValue(label: 'Account No.', value: '9704 0000 1234 5678'),
            ],
          ),
          Stacked(
            gap: 8,
            children: [
              LabeledValue(label: 'Amount', value: amountDue),
              const _QrPlaceholder(),
            ],
          ),
        ],
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF132238).withValues(alpha: 0.12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
            ),
            itemCount: 81,
            itemBuilder: (context, index) {
              final row = index ~/ 9;
              final col = index % 9;
              final isFinder =
                  (row < 3 && col < 3) ||
                  (row < 3 && col > 5) ||
                  (row > 5 && col < 3);
              final isFilled = isFinder || (row * 7 + col * 3) % 5 == 0;
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: isFilled
                      ? const Color(0xFF132238)
                      : const Color(0xFFE8EDF2),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
