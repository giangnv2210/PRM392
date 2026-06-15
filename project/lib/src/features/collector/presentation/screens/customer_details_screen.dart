import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_collector_work_repository.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MockCollectorWorkRepository.instance;
    final customer = repository.selectedCustomer();
    final bills = repository.billsForSelectedCustomer();
    final unpaidCount = bills
        .where((bill) => bill.status.canProceedToPayment)
        .length;

    return AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'Customer Details Screen',
      backLabel: 'Assigned Customers',
      backRoute: AppRoutes.assignedCustomers,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              HeroPanel(
                child: Stacked(
                  children: [
                    SectionHeader(
                      title: customer.name,
                      subtitle: '${customer.phone} | ${customer.meterNumber}',
                    ),
                    Text(
                      'Address: ${customer.address}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F6B7A),
                      ),
                    ),
                    Text(
                      'QR / Meter Token: ${customer.meterToken}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F6B7A),
                      ),
                    ),
                    StatusPill('$unpaidCount unpaid bill(s)'),
                  ],
                ),
              ),
              AppCard(
                child: Stacked(
                  children: [
                    const Text(
                      'Customer notes',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      customer.notes,
                      style: const TextStyle(
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
                  AppAction(
                    'Bills',
                    route: AppRoutes.customerBills,
                    primary: true,
                  ),
                  AppAction('View Complaints', route: AppRoutes.viewComplaints),
                ],
              ),
              ActionBar(actions: [AppAction('Call Customer')]),
            ],
          ),
        ),
      ],
    );
  }
}
