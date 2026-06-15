import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';

class ViewComplaintsScreen extends StatelessWidget {
  const ViewComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'View Complaints Screen',
      backLabel: 'Customer Details',
      backRoute: AppRoutes.customerDetails,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              ListRecordTile(
                title: 'Billing dispute',
                subtitle: 'Gui ngay 18/05/2026 | Dang mo',
                note:
                    'Khach hang cho biet tien nuoc ky nay cao hon binh thuong.',
                extra: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppChip('Attachment preview'),
                      AppChip('Status: Pending'),
                    ],
                  ),
                ],
              ),
              ListRecordTile(
                title: 'Water supply issue',
                subtitle: 'Gui ngay 02/05/2026 | Dang xem xet',
                note: 'Khach hang bao ap luc nuoc yeu trong 2 ngay.',
                extra: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppChip('No attachment'),
                      AppChip('Status: In Progress'),
                    ],
                  ),
                ],
              ),
              AppCard(
                accent: true,
                child: Stacked(
                  children: [
                    Text(
                      'Status update',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    AppField(
                      label: 'Handling Note',
                      hintText: 'Add handling note for the selected complaint',
                      maxLines: 4,
                    ),
                    ActionBar(
                      actions: [
                        AppAction('Mark In Progress'),
                        AppAction('Resolve Complaint', primary: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
