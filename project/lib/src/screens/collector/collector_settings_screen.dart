import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class CollectorSettingsScreen extends StatelessWidget {
  const CollectorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.collector,
      title: 'Collector Settings Screen',
      backLabel: 'Collector Dashboard',
      backRoute: AppRoutes.collectorDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              ToggleOptionCard(
                title: 'Notifications',
                subtitle:
                    'Task reminders, payment alerts, and overdue follow-ups.',
                initialValue: true,
              ),
              MockupCard(
                child: MockField(
                  label: 'Language',
                  options: ['Vietnamese', 'English'],
                  dropdownValue: 'Vietnamese',
                ),
              ),
              ActionBar(
                actions: [MockAction('Change Password', primary: true)],
              ),
              ActionBar(
                actions: [MockAction('Logout', route: AppRoutes.login)],
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'Back to Dashboard',
                    route: AppRoutes.collectorDashboard,
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
