import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_collector_work_repository.dart';
import '../../domain/models/customer_bill.dart';

class BillDetailsScreen extends StatefulWidget {
  const BillDetailsScreen({super.key});

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  final _repository = MockCollectorWorkRepository.instance;

  Future<void> _showEditBillSheet(CustomerBill bill) async {
    final screenContext = context;
    final billingPeriodController = TextEditingController(
      text: bill.billingPeriod,
    );
    final readingController = TextEditingController(
      text: '${bill.currentReading}',
    );
    final readingDateController = TextEditingController(text: bill.readingDate);
    final dueDateController = TextEditingController(text: bill.dueDate);
    final meterPhotoController = TextEditingController(text: bill.meterPhoto);
    final noteController = TextEditingController(text: bill.note);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        void save() {
          final currentReading = int.tryParse(readingController.text.trim());
          if (currentReading == null) {
            showAppMessage(context, 'Enter a valid current reading.');
            return;
          }
          if (currentReading < bill.previousReading) {
            showAppMessage(
              context,
              'Current reading cannot be lower than previous reading.',
            );
            return;
          }

          final billingPeriod = billingPeriodController.text.trim();
          final dueDate = dueDateController.text.trim();
          final readingDate = readingDateController.text.trim();
          final meterPhoto = meterPhotoController.text.trim();
          if ([billingPeriod, dueDate, readingDate, meterPhoto].any((value) {
            return value.isEmpty;
          })) {
            showAppMessage(context, 'Complete all bill fields.');
            return;
          }

          setState(() {
            _repository.updateSelectedBill(
              billingPeriod: billingPeriod,
              currentReading: currentReading,
              dueDate: dueDate,
              readingDate: readingDate,
              meterPhoto: meterPhoto,
              note: noteController.text,
            );
          });
          Navigator.of(context).pop();
          showAppMessage(screenContext, 'Bill updated.');
        }

        return AppModalSheet(
          theme: ScreenThemeVariant.collector,
          title: 'Edit unpaid bill',
          children: [
            ResponsiveGrid(
              children: [
                LabeledValue(
                  label: 'Previous Reading',
                  value: '${bill.previousReading}',
                ),
                LabeledValue(label: 'Current Amount', value: bill.amountLabel),
              ],
            ),
            AppField(
              label: 'Billing Period',
              controller: billingPeriodController,
            ),
            AppField(
              label: 'Current Reading',
              controller: readingController,
              keyboardType: TextInputType.number,
            ),
            ResponsiveGrid(
              children: [
                AppField(
                  label: 'Reading Date',
                  controller: readingDateController,
                ),
                AppField(label: 'Due Date', controller: dueDateController),
              ],
            ),
            AppField(label: 'Meter Photo', controller: meterPhotoController),
            AppField(
              label: 'Bill Note',
              controller: noteController,
              maxLines: 4,
            ),
            ActionBar(
              actions: [
                AppAction('Cancel', onPressed: () => Navigator.pop(context)),
                AppAction('Save', primary: true, onPressed: save),
              ],
            ),
          ],
        );
      },
    );

    billingPeriodController.dispose();
    readingController.dispose();
    readingDateController.dispose();
    dueDateController.dispose();
    meterPhotoController.dispose();
    noteController.dispose();
  }

  Future<void> _deleteBill(CustomerBill bill) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete unpaid bill?'),
          content: Text('${bill.id} will be removed from this customer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }

    _repository.deleteSelectedBill();
    showAppMessage(context, '${bill.id} deleted.');
    openAppRoute(context, AppRoutes.customerBills, replaceRoute: true);
  }

  @override
  Widget build(BuildContext context) {
    final customer = _repository.selectedCustomer();
    final bill = _repository.selectedBill();
    final isUnpaid = bill.status.canProceedToPayment;

    return AppScreen(
      theme: ScreenThemeVariant.collector,
      title: 'Bill Details Screen',
      backLabel: 'Customer Bills',
      backRoute: AppRoutes.customerBills,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              HeroPanel(
                child: Stacked(
                  children: [
                    ResponsiveGrid(
                      children: [
                        LabeledValue(label: 'Bill ID', value: bill.id),
                        Stacked(
                          gap: 10,
                          children: [
                            const Text(
                              'Payment Status',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            StatusPill(bill.status.label),
                          ],
                        ),
                      ],
                    ),
                    ResponsiveGrid(
                      children: [
                        LabeledValue(
                          label: 'Billing Month',
                          value: bill.billingPeriod,
                        ),
                        LabeledValue(
                          label: 'Customer Name',
                          value: customer.name,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ResponsiveGrid(
                children: [
                  DetailTile(
                    label: 'Meter Number',
                    value: customer.meterNumber,
                  ),
                  DetailTile(
                    label: 'Previous Reading',
                    value: '${bill.previousReading}',
                  ),
                  DetailTile(
                    label: 'Current Reading',
                    value: '${bill.currentReading}',
                  ),
                  DetailTile(label: 'Water Usage', value: '${bill.usageM3} m3'),
                  DetailTile(label: 'Total Amount', value: bill.amountLabel),
                  DetailTile(label: 'Due Date', value: bill.dueDate),
                  DetailTile(label: 'Reading Date', value: bill.readingDate),
                  DetailTile(label: 'Meter Photo', value: bill.meterPhoto),
                ],
              ),
              AppCard(
                child: Stacked(
                  gap: 10,
                  children: [
                    const Text(
                      'Payment Information',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      isUnpaid
                          ? 'This bill is unpaid. You can edit the bill details, delete it, or proceed to payment.'
                          : 'Collected by ${bill.paymentMethod ?? 'Cash'} on ${bill.paidAt ?? 'Today'}. Receipt information is available after payment confirmation.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F6B7A),
                        height: 1.45,
                      ),
                    ),
                    if (bill.note != null)
                      Text(
                        'Note: ${bill.note}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5F6B7A),
                          height: 1.45,
                        ),
                      ),
                  ],
                ),
              ),
              if (isUnpaid)
                ActionBar(
                  actions: [
                    AppAction(
                      'Edit Bill',
                      onPressed: () => _showEditBillSheet(bill),
                    ),
                    AppAction(
                      'Delete Bill',
                      danger: true,
                      onPressed: () => _deleteBill(bill),
                    ),
                  ],
                ),
              ActionBar(
                actions: [
                  if (isUnpaid)
                    AppAction(
                      'Proceed to Payment',
                      route: AppRoutes.collectPayment,
                      primary: true,
                    )
                  else
                    AppAction('View Receipt', primary: true),
                  AppAction('Back', route: AppRoutes.customerBills),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
