import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_admin_repository.dart';
import '../../domain/models/admin_record_status.dart';
import '../../domain/models/collector.dart';
import '../../domain/repositories/admin_repository.dart';

class ManageCollectorsScreen extends StatefulWidget {
  const ManageCollectorsScreen({super.key});

  @override
  State<ManageCollectorsScreen> createState() => _ManageCollectorsScreenState();
}

class _ManageCollectorsScreenState extends State<ManageCollectorsScreen> {
  final AdminRepository _repository = MockAdminRepository.instance;
  final _searchController = TextEditingController();
  final Set<String> _selectedCollectorIds = <String>{};
  var _statusFilter = 'All';

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

  List<Collector> get _filteredCollectors {
    final query = _searchController.text.trim().toLowerCase();
    return _repository.listCollectors().where((collector) {
      final matchesStatus =
          _statusFilter == 'All' || collector.status.label == _statusFilter;
      final searchable = [
        collector.name,
        collector.phone,
        collector.area,
      ].join(' ').toLowerCase();
      return matchesStatus && (query.isEmpty || searchable.contains(query));
    }).toList();
  }

  List<Collector> get _selectedCollectors {
    return _repository
        .listCollectors()
        .where((collector) => _selectedCollectorIds.contains(collector.id))
        .toList();
  }

  void _toggleCollectorSelection(String collectorId, bool selected) {
    setState(() {
      if (selected) {
        _selectedCollectorIds.add(collectorId);
      } else {
        _selectedCollectorIds.remove(collectorId);
      }
    });
  }

  void _selectAllVisibleCollectors() {
    final visibleIds = _filteredCollectors.map((collector) => collector.id);
    setState(() => _selectedCollectorIds.addAll(visibleIds));
  }

  void _clearCollectorSelection() {
    setState(_selectedCollectorIds.clear);
  }

  void _syncCollectorSelection() {
    final validIds = _repository
        .listCollectors()
        .map((collector) => collector.id)
        .toSet();
    _selectedCollectorIds.removeWhere(
      (collectorId) => !validIds.contains(collectorId),
    );
  }

  Future<void> _showCollectorForm({Collector? collector}) async {
    final screenContext = context;
    final nameController = TextEditingController(text: collector?.name);
    final phoneController = TextEditingController(text: collector?.phone);
    final areaController = TextEditingController(text: collector?.area);
    var status = collector?.status ?? AdminRecordStatus.active;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void save() {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              final area = areaController.text.trim();
              if ([name, phone, area].any((value) => value.isEmpty)) {
                showAppMessage(context, 'Complete all collector fields.');
                return;
              }

              setState(() {
                if (collector == null) {
                  _repository.createCollector(
                    CollectorDraft(
                      name: name,
                      phone: phone,
                      area: area,
                      status: status,
                    ),
                  );
                } else {
                  _repository.updateCollector(
                    collector.copyWith(
                      name: name,
                      phone: phone,
                      area: area,
                      status: status,
                    ),
                  );
                }
              });
              Navigator.of(context).pop();
              showAppMessage(
                screenContext,
                collector == null ? 'Collector added.' : 'Collector updated.',
              );
            }

            return AppModalSheet(
              title: collector == null ? 'Add collector' : 'Edit collector',
              children: [
                AppField(
                  label: 'Collector Name',
                  hintText: 'Enter collector name',
                  controller: nameController,
                ),
                ResponsiveGrid(
                  children: [
                    AppField(
                      label: 'Phone',
                      hintText: '09xx xxx xxxx',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    AppField(
                      label: 'Area',
                      hintText: 'Route or ward',
                      controller: areaController,
                    ),
                  ],
                ),
                AppDropdownField<AdminRecordStatus>(
                  label: 'Status',
                  value: status,
                  items: AdminRecordStatus.values,
                  itemLabel: (item) => item.label,
                  onChanged: (value) {
                    if (value != null) {
                      setSheetState(() => status = value);
                    }
                  },
                ),
                ActionBar(
                  actions: [
                    AppAction(
                      'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                    AppAction('Save', primary: true, onPressed: save),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();
    areaController.dispose();
  }

  Future<void> _assignCustomers(Collector collector) async {
    final screenContext = context;
    final selectedCustomerIds = collector.customerIds.toSet();
    final customers = _repository.listCustomers();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void save() {
              setState(() {
                _repository.assignCustomersToCollector(
                  collector.id,
                  selectedCustomerIds.toList(),
                );
              });
              Navigator.of(context).pop();
              showAppMessage(screenContext, 'Customer assignments updated.');
            }

            return AppModalSheet(
              title: 'Assign customers',
              children: [
                ListRecordTile(
                  title: collector.name,
                  subtitle:
                      '${collector.phone} | ${collector.area} | ${collector.status.label}',
                ),
                if (customers.isEmpty)
                  const EmptyStateCard(
                    title: 'No customers available',
                    message: 'Add customers before assigning them.',
                  )
                else
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Stacked(
                      gap: 0,
                      children: [
                        for (final customer in customers)
                          CheckboxListTile(
                            value: selectedCustomerIds.contains(customer.id),
                            onChanged: (value) {
                              setSheetState(() {
                                if (value == true) {
                                  selectedCustomerIds.add(customer.id);
                                } else {
                                  selectedCustomerIds.remove(customer.id);
                                }
                              });
                            },
                            title: Text(customer.name),
                            subtitle: Text(
                              '${customer.address} | ${customer.meterNumber}',
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                      ],
                    ),
                  ),
                ActionBar(
                  actions: [
                    AppAction(
                      'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                    AppAction('Save', primary: true, onPressed: save),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deactivateCollector(Collector collector) {
    setState(() => _repository.deactivateCollector(collector.id));
    showAppMessage(context, '${collector.name} deactivated.');
  }

  void _updateSelectedCollectorsStatus(AdminRecordStatus status) {
    final selectedCollectors = _selectedCollectors;
    if (selectedCollectors.isEmpty) {
      showAppMessage(context, 'Select at least one collector first.');
      return;
    }

    setState(() {
      for (final collector in selectedCollectors) {
        _repository.updateCollector(collector.copyWith(status: status));
      }
    });
    showAppMessage(
      context,
      '${selectedCollectors.length} collector(s) marked ${status.label.toLowerCase()}.',
    );
  }

  Future<void> _deleteCollector(Collector collector) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove collector?'),
          content: Text(
            '${collector.name} will be removed and their customer assignments will be cleared.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _repository.deleteCollector(collector.id);
      _selectedCollectorIds.remove(collector.id);
    });
    showAppMessage(context, '${collector.name} removed.');
  }

  Future<void> _deleteSelectedCollectors() async {
    final selectedCollectors = _selectedCollectors;
    if (selectedCollectors.isEmpty) {
      showAppMessage(context, 'Select at least one collector first.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove selected collectors?'),
          content: Text(
            '${selectedCollectors.length} selected collector(s) will be removed and their assignments will be cleared.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      for (final collector in selectedCollectors) {
        _repository.deleteCollector(collector.id);
      }
      _syncCollectorSelection();
    });
    showAppMessage(
      context,
      '${selectedCollectors.length} collector(s) removed.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final collectors = _filteredCollectors;
    final selectedCount = _selectedCollectors.length;
    final activeCount = _repository
        .listCollectors()
        .where((collector) => collector.status == AdminRecordStatus.active)
        .length;

    return AppScreen(
      theme: ScreenThemeVariant.admin,
      title: 'Manage Collectors Screen',
      backLabel: 'Admin Dashboard',
      backRoute: AppRoutes.adminDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              SectionHeader(
                title: 'Collectors',
                subtitle:
                    '$activeCount active of ${_repository.listCollectors().length} total',
                trailing: SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () => _showCollectorForm(),
                    child: const Icon(Icons.add_rounded, size: 20),
                  ),
                ),
              ),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: ResponsiveGrid(
                  children: [
                    AppField(
                      label: 'Search',
                      hintText: 'Name, phone, area',
                      controller: _searchController,
                    ),
                    AppField(
                      label: 'Status',
                      options: const ['All', 'Active', 'Inactive'],
                      dropdownValue: _statusFilter,
                      onDropdownChanged: (value) {
                        setState(() => _statusFilter = value ?? 'All');
                      },
                    ),
                  ],
                ),
              ),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Stacked(
                  gap: 14,
                  children: [
                    Text(
                      selectedCount == 0
                          ? 'Select one or more collectors to run batch actions.'
                          : '$selectedCount collector(s) selected',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        AppActionButton(
                          action: AppAction(
                            'Select Visible',
                            icon: Icons.select_all_rounded,
                            tiny: true,
                            onPressed: _selectAllVisibleCollectors,
                          ),
                        ),
                        AppActionButton(
                          action: AppAction(
                            'Clear Selection',
                            icon: Icons.deselect_rounded,
                            tiny: true,
                            onPressed: _clearCollectorSelection,
                          ),
                        ),
                        if (selectedCount > 0) ...[
                          AppActionButton(
                            action: AppAction(
                              'Mark Active',
                              icon: Icons.check_circle_rounded,
                              tiny: true,
                              onPressed: () => _updateSelectedCollectorsStatus(
                                AdminRecordStatus.active,
                              ),
                            ),
                          ),
                          AppActionButton(
                            action: AppAction(
                              'Deactivate',
                              tiny: true,
                              onPressed: () => _updateSelectedCollectorsStatus(
                                AdminRecordStatus.inactive,
                              ),
                            ),
                          ),
                          AppActionButton(
                            action: AppAction(
                              'Remove Selected',
                              danger: true,
                              tiny: true,
                              onPressed: _deleteSelectedCollectors,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (collectors.isEmpty)
                const EmptyStateCard(
                  title: 'No collectors found',
                  message: 'Adjust the search or add a new collector.',
                )
              else
                ...collectors.map((collector) {
                  return ListRecordTile(
                    title: collector.name,
                    subtitle:
                        '${collector.phone} | ${collector.area} | ${collector.customerIds.length} customers',
                    headerTrailing: Checkbox.adaptive(
                      value: _selectedCollectorIds.contains(collector.id),
                      onChanged: (value) {
                        _toggleCollectorSelection(collector.id, value ?? false);
                      },
                    ),
                    extra: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          AppChip('Status: ${collector.status.label}'),
                          AppChip('Assigned: ${collector.customerIds.length}'),
                        ],
                      ),
                    ],
                    actions: [
                      AppAction(
                        'Edit',
                        onPressed: () =>
                            _showCollectorForm(collector: collector),
                      ),
                      AppAction(
                        'Assign',
                        onPressed: () => _assignCustomers(collector),
                      ),
                      AppAction(
                        'Deactivate',
                        onPressed: () => _deactivateCollector(collector),
                      ),
                      AppAction(
                        'Remove',
                        danger: true,
                        onPressed: () => _deleteCollector(collector),
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
