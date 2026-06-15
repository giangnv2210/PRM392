import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';

class CollectorSettingsScreen extends StatelessWidget {
  const CollectorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
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
              AppCard(
                child: AppField(
                  label: 'Language',
                  options: ['Vietnamese', 'English'],
                  dropdownValue: 'Vietnamese',
                ),
              ),
              ActionBar(actions: [AppAction('Change Password', primary: true)]),
              ActionBar(actions: [AppAction('Logout', route: AppRoutes.login)]),
              ActionBar(
                actions: [
                  AppAction(
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
