import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
      theme: ScreenThemeVariant.admin,
      title: 'Admin Settings Screen',
      backLabel: 'Admin Dashboard',
      backRoute: AppRoutes.adminDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              AppCard(
                child: Stacked(
                  children: [
                    Text(
                      'Billing cycle and due date',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    AppField(
                      label: 'Water Rate Per Unit',
                      initialValue: '29,643 VND',
                    ),
                    AppField(label: 'Billing Cycle', initialValue: 'Monthly'),
                    AppField(label: 'Default Due Days', initialValue: '5'),
                    AppField(
                      label: 'Due Date Rule',
                      initialValue: 'Every 5th day',
                    ),
                  ],
                ),
              ),
              AppCard(
                child: Stacked(
                  children: [
                    Text(
                      'Late fee and payment methods',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    AppField(
                      label: 'Late Payment Fee',
                      initialValue: '5% of total due',
                    ),
                    AppField(
                      label: 'Supported Methods',
                      initialValue: 'Cash, Bank Transfer',
                    ),
                    AppField(
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
                  AppAction('Save Settings', primary: true),
                  AppAction('Discard Changes', route: AppRoutes.adminDashboard),
                ],
              ),
              ActionBar(actions: [AppAction('Logout', route: AppRoutes.login)]),
            ],
          ),
        ),
      ],
    );
  }
}
