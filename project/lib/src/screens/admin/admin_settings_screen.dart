import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.admin,
      title: 'Admin Settings Screen',
      backLabel: 'Admin Dashboard',
      backRoute: AppRoutes.adminDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockupCard(
                child: Stacked(
                  children: [
                    Text(
                      'Billing cycle and due date',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    MockField(
                      label: 'Water Rate Per Unit',
                      initialValue: '29,643 VND',
                    ),
                    MockField(label: 'Billing Cycle', initialValue: 'Monthly'),
                    MockField(label: 'Default Due Days', initialValue: '5'),
                    MockField(
                      label: 'Due Date Rule',
                      initialValue: 'Every 5th day',
                    ),
                  ],
                ),
              ),
              MockupCard(
                child: Stacked(
                  children: [
                    Text(
                      'Late fee and payment methods',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    MockField(
                      label: 'Late Payment Fee',
                      initialValue: '5% of total due',
                    ),
                    MockField(
                      label: 'Supported Methods',
                      initialValue: 'Cash, GCash, Bank Transfer, Card',
                    ),
                    MockField(
                      label: 'Notification Template',
                      hintText:
                          'Billing, overdue, and payment reminder content',
                      initialValue:
                          'Reminder: your water bill is due on {due_date}. Please pay before {deadline}.',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              ToggleOptionCard(
                title: 'Notification and security',
                subtitle:
                    'Enable admin alerts for overdue spikes and failed payment jobs.',
                initialValue: true,
              ),
              ActionBar(
                actions: [
                  MockAction('Save Settings', primary: true),
                  MockAction(
                    'Discard Changes',
                    route: AppRoutes.adminDashboard,
                  ),
                ],
              ),
              ActionBar(
                actions: [MockAction('Logout', route: AppRoutes.login)],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
