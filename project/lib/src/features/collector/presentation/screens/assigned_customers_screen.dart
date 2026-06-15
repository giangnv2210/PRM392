import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_collector_work_repository.dart';
import '../../domain/models/bill_status.dart';
import '../../domain/models/customer_bill.dart';

class AssignedCustomersScreen extends StatefulWidget {
  const AssignedCustomersScreen({super.key});

  @override
  State<AssignedCustomersScreen> createState() =>
      _AssignedCustomersScreenState();
}

class _AssignedCustomersScreenState extends State<AssignedCustomersScreen> {
  final _repository = MockCollectorWorkRepository.instance;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final customers = _repository.assignedCustomers().where((customer) {
      final searchable = [
        customer.name,
        customer.phone,
        customer.address,
        customer.meterNumber,
      ].join(' ').toLowerCase();
      return query.isEmpty || searchable.contains(query);
    }).toList();

    return AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'Assigned Customers',
      backLabel: 'Collector Dashboard',
      backRoute: AppRoutes.collectorDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              SectionHeader(
                title: 'Assigned customers',
                subtitle: '${customers.length} visible accounts',
              ),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: AppField(
                  label: 'Search',
                  hintText: 'Name, phone, address, or meter',
                  controller: _searchController,
                ),
              ),
              if (customers.isEmpty)
                const EmptyStateCard(
                  title: 'No assigned customers found',
                  message: 'Adjust the search text and try again.',
                )
              else
                ...customers.map((customer) {
                  final bills = _repository.billsForCustomer(customer.id);
                  final unpaidBills = bills
                      .where((bill) => bill.status != BillStatus.paid)
                      .toList();
                  final latestUnpaidBill = unpaidBills.isEmpty
                      ? null
                      : unpaidBills.first;

                  return ListRecordTile(
                    title: customer.name,
                    subtitle:
                        '${customer.phone} | ${customer.address} | ${customer.meterNumber}',
                    note: customer.notes,
                    extra: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          AppChip('Bills: ${bills.length}'),
                          AppChip('Unpaid: ${unpaidBills.length}'),
                          AppChip(customer.meterToken),
                        ],
                      ),
                    ],
                    actions: [
                      AppAction(
                        'View Details',
                        primary: true,
                        onPressed: () {
                          _repository.selectCustomer(customer.id);
                          openAppRoute(context, AppRoutes.customerDetails);
                        },
                      ),
                      AppAction(
                        'Collect Payment',
                        onPressed: () => _collectPayment(
                          context,
                          customer.id,
                          latestUnpaidBill,
                        ),
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

  void _collectPayment(
    BuildContext context,
    String customerId,
    CustomerBill? latestUnpaidBill,
  ) {
    _repository.selectCustomer(customerId);
    if (latestUnpaidBill == null) {
      showAppMessage(context, 'This customer has no unpaid bills.');
      openAppRoute(context, AppRoutes.customerBills);
      return;
    }
    _repository.selectBill(latestUnpaidBill.id);
    openAppRoute(context, AppRoutes.collectPayment);
  }
}
