import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_collector_work_repository.dart';
import '../../domain/models/bill_status.dart';
import '../../domain/models/customer_bill.dart';

class CollectorDashboardScreen extends StatelessWidget {
  const CollectorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MockCollectorWorkRepository.instance;
    final customers = repository.assignedCustomers();
    final bills = customers
        .expand((customer) => repository.billsForCustomer(customer.id))
        .toList();
    final unpaidCount = bills
        .where((bill) => bill.status != BillStatus.paid)
        .length;
    final collectedTotal = bills
        .where((bill) => bill.status == BillStatus.paid)
        .fold<int>(0, (total, bill) => total + bill.amountDue);
    final overdueCount = bills
        .where((bill) => bill.status == BillStatus.overdue)
        .length;

    return AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'Collector Dashboard',
      subtitle:
          'Track assigned customers, daily collections, and open the QR flow to jump straight to a meter record.',
      showHeader: true,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              ResponsiveGrid(
                children: [
                  MetricTile(
                    title: 'Assigned Customers',
                    value: '${customers.length} meters today',
                  ),
                  MetricTile(
                    title: 'Pending Collections',
                    value: '$unpaidCount bills',
                  ),
                  MetricTile(
                    title: 'Collected Today',
                    value: formatVnd(collectedTotal),
                  ),
                  MetricTile(
                    title: 'Overdue Alerts',
                    value: '$overdueCount accounts',
                  ),
                ],
              ),
              HeroPanel(
                child: Stacked(
                  children: [
                    StatusPill('Daily Summary'),
                    AppCard(
                      child: Stacked(
                        gap: 14,
                        children: [
                          for (final customer in customers.take(3))
                            _DailySummaryCustomerTile(
                              customerId: customer.id,
                              title: customer.name,
                              subtitle:
                                  '${customer.address} | ${customer.meterNumber} | ${_billSummary(repository, customer.id)}',
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  AppAction('Scan QR', route: AppRoutes.scanQr, primary: true),
                  AppAction(
                    'Assigned Customers',
                    route: AppRoutes.assignedCustomers,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  AppAction('Settings', route: AppRoutes.collectorSettings),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _billSummary(
    MockCollectorWorkRepository repository,
    String customerId,
  ) {
    final bills = repository.billsForCustomer(customerId);
    final unpaidBills = bills.where((bill) => bill.status != BillStatus.paid);
    if (unpaidBills.isEmpty) {
      return 'Paid';
    }
    final totalDue = unpaidBills.fold<int>(
      0,
      (total, bill) => total + bill.amountDue,
    );
    return 'Due | ${formatVnd(totalDue)}';
  }
}

class _DailySummaryCustomerTile extends StatelessWidget {
  const _DailySummaryCustomerTile({
    required this.customerId,
    required this.title,
    required this.subtitle,
  });

  final String customerId;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final repository = MockCollectorWorkRepository.instance;
    return ListRecordTile(
      title: title,
      subtitle: subtitle,
      actions: [
        AppAction(
          'Review',
          onPressed: () {
            repository.selectCustomer(customerId);
            openAppRoute(context, AppRoutes.customerDetails);
          },
        ),
      ],
    );
  }
}
