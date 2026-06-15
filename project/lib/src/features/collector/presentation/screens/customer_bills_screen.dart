import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_collector_work_repository.dart';
import '../../domain/models/bill_status.dart';

class CustomerBillsScreen extends StatefulWidget {
  const CustomerBillsScreen({super.key});

  @override
  State<CustomerBillsScreen> createState() => _CustomerBillsScreenState();
}

class _CustomerBillsScreenState extends State<CustomerBillsScreen> {
  final _repository = MockCollectorWorkRepository.instance;
  var _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final customer = _repository.selectedCustomer();
    final bills = _repository.billsForSelectedCustomer().where((bill) {
      return _statusFilter == 'All' || bill.status.label == _statusFilter;
    }).toList();
    final unpaidCount = _repository
        .billsForSelectedCustomer()
        .where((bill) => bill.status != BillStatus.paid)
        .length;

    return AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'Customer Bills',
      backLabel: 'Customer Details',
      backRoute: AppRoutes.customerDetails,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              SectionHeader(
                title: '${customer.name} bills',
                subtitle: '$unpaidCount unpaid bill(s)',
                trailing: SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () => openAppRoute(context, AppRoutes.newBill),
                    child: const Icon(Icons.add_rounded, size: 20),
                  ),
                ),
              ),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: AppField(
                  label: 'Status',
                  options: const ['All', 'Unpaid', 'Overdue', 'Paid'],
                  dropdownValue: _statusFilter,
                  onDropdownChanged: (value) {
                    setState(() => _statusFilter = value ?? 'All');
                  },
                ),
              ),
              if (bills.isEmpty)
                const EmptyStateCard(
                  title: 'No bills found',
                  message: 'Create a new bill for this customer.',
                )
              else
                ...bills.map((bill) {
                  return ListRecordTile(
                    title: '${bill.billingPeriod} | ${bill.id}',
                    subtitle:
                        '${bill.amountLabel} | Usage: ${bill.usageM3} m3 | Due: ${bill.dueDate}',
                    extra: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          AppChip('Status: ${bill.status.label}'),
                          AppChip(
                            '${bill.previousReading} -> ${bill.currentReading}',
                          ),
                        ],
                      ),
                    ],
                    actions: [
                      AppAction(
                        'Details',
                        onPressed: () {
                          _repository.selectBill(bill.id);
                          openAppRoute(context, AppRoutes.billDetails);
                        },
                      ),
                      if (bill.status.canProceedToPayment)
                        AppAction(
                          'Proceed to Payment',
                          primary: true,
                          onPressed: () {
                            _repository.selectBill(bill.id);
                            openAppRoute(context, AppRoutes.collectPayment);
                          },
                        ),
                    ],
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}
