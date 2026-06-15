import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../data/mock_admin_repository.dart';
import '../../domain/models/admin_record_status.dart';
import '../../domain/models/customer.dart';
import '../../domain/repositories/admin_repository.dart';

class ManageCustomersScreen extends StatefulWidget {
  const ManageCustomersScreen({super.key});

  @override
  State<ManageCustomersScreen> createState() => _ManageCustomersScreenState();
}

class _ManageCustomersScreenState extends State<ManageCustomersScreen> {
  final AdminRepository _repository = MockAdminRepository.instance;
  final _searchController = TextEditingController();
  final Set<String> _selectedCustomerIds = <String>{};
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

  List<Customer> get _filteredCustomers {
    final query = _searchController.text.trim().toLowerCase();
    return _repository.listCustomers().where((customer) {
      final matchesStatus =
          _statusFilter == 'All' || customer.status.label == _statusFilter;
      final collectorName = _collectorName(customer.assignedCollectorId);
      final searchable = [
        customer.name,
        customer.phone,
        customer.address,
        customer.meterNumber,
        collectorName,
      ].join(' ').toLowerCase();
      return matchesStatus && (query.isEmpty || searchable.contains(query));
    }).toList();
  }

  List<Customer> get _selectedCustomers {
    return _repository
        .listCustomers()
        .where((customer) => _selectedCustomerIds.contains(customer.id))
        .toList();
  }

  void _toggleCustomerSelection(String customerId, bool selected) {
    setState(() {
      if (selected) {
        _selectedCustomerIds.add(customerId);
      } else {
        _selectedCustomerIds.remove(customerId);
      }
    });
  }

  void _selectAllVisibleCustomers() {
    final visibleIds = _filteredCustomers.map((customer) => customer.id);
    setState(() => _selectedCustomerIds.addAll(visibleIds));
  }

  void _clearCustomerSelection() {
    setState(_selectedCustomerIds.clear);
  }

  void _syncCustomerSelection() {
    final validIds = _repository
        .listCustomers()
        .map((customer) => customer.id)
        .toSet();
    _selectedCustomerIds.removeWhere(
      (customerId) => !validIds.contains(customerId),
    );
  }

  String _collectorName(String? collectorId) {
    if (collectorId == null) {
      return 'Unassigned';
    }
    for (final collector in _repository.listCollectors()) {
      if (collector.id == collectorId) {
        return collector.name;
      }
    }
    return 'Unassigned';
  }

  Future<void> _showCustomerForm({Customer? customer}) async {
    final screenContext = context;
    final nameController = TextEditingController(text: customer?.name);
    final phoneController = TextEditingController(text: customer?.phone);
    final addressController = TextEditingController(text: customer?.address);
    final meterController = TextEditingController(text: customer?.meterNumber);
    var status = customer?.status ?? AdminRecordStatus.active;
    var assignedCollectorId = customer?.assignedCollectorId;
    var qrGenerated = customer?.qrGenerated ?? false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void save() {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              final address = addressController.text.trim();
              final meter = meterController.text.trim();
              if ([name, phone, address, meter].any((value) => value.isEmpty)) {
                showAppMessage(context, 'Complete all customer fields.');
                return;
              }

              setState(() {
                if (customer == null) {
                  _repository.createCustomer(
                    CustomerDraft(
                      name: name,
                      phone: phone,
                      address: address,
                      meterNumber: meter,
                      assignedCollectorId: assignedCollectorId,
                      status: status,
                      qrGenerated: qrGenerated,
                    ),
                  );
                } else {
                  _repository.updateCustomer(
                    customer.copyWith(
                      name: name,
                      phone: phone,
                      address: address,
                      meterNumber: meter,
                      status: status,
                      assignedCollectorId: assignedCollectorId,
                      clearAssignedCollector: assignedCollectorId == null,
                      qrGenerated: qrGenerated,
                    ),
                  );
                }
              });
              Navigator.of(context).pop();
              showAppMessage(
                screenContext,
                customer == null ? 'Customer added.' : 'Customer updated.',
              );
            }

            return AppModalSheet(
              title: customer == null ? 'Add customer' : 'Edit customer',
              children: [
                AppField(
                  label: 'Customer Name',
                  hintText: 'Enter customer name',
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
                      label: 'Meter Number',
                      hintText: 'WM-00000',
                      controller: meterController,
                    ),
                  ],
                ),
                AppField(
                  label: 'Address',
                  hintText: 'Enter service address',
                  controller: addressController,
                  maxLines: 2,
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
                AppDropdownField<String?>(
                  label: 'Assigned Collector',
                  value: assignedCollectorId,
                  items: [
                    null,
                    ..._repository.listCollectors().map((collector) {
                      return collector.id;
                    }),
                  ],
                  itemLabel: _collectorName,
                  onChanged: (value) {
                    setSheetState(() => assignedCollectorId = value);
                  },
                ),
                SwitchListTile.adaptive(
                  value: qrGenerated,
                  onChanged: (value) {
                    setSheetState(() => qrGenerated = value);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: const Text('QR generated'),
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
    addressController.dispose();
    meterController.dispose();
  }

  Future<void> _assignCollector(Customer customer) async {
    final screenContext = context;
    var assignedCollectorId = customer.assignedCollectorId;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void save() {
              setState(() {
                _repository.assignCollectorToCustomer(
                  customer.id,
                  assignedCollectorId,
                );
              });
              Navigator.of(context).pop();
              showAppMessage(screenContext, 'Collector assignment updated.');
            }

            return AppModalSheet(
              title: 'Assign collector',
              children: [
                ListRecordTile(
                  title: customer.name,
                  subtitle: '${customer.address} | ${customer.meterNumber}',
                ),
                AppDropdownField<String?>(
                  label: 'Collector',
                  value: assignedCollectorId,
                  items: [
                    null,
                    ..._repository.listCollectors().map((collector) {
                      return collector.id;
                    }),
                  ],
                  itemLabel: _collectorName,
                  onChanged: (value) {
                    setSheetState(() => assignedCollectorId = value);
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
  }

  Future<void> _assignCollectorToSelectedCustomers() async {
    final selectedCustomers = _selectedCustomers;
    if (selectedCustomers.isEmpty) {
      showAppMessage(context, 'Select at least one customer first.');
      return;
    }

    final screenContext = context;
    String? assignedCollectorId;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void save() {
              setState(() {
                for (final customer in selectedCustomers) {
                  _repository.assignCollectorToCustomer(
                    customer.id,
                    assignedCollectorId,
                  );
                }
              });
              Navigator.of(context).pop();
              showAppMessage(
                screenContext,
                'Collector updated for ${selectedCustomers.length} customer(s).',
              );
            }

            return AppModalSheet(
              title: 'Assign collector to selected customers',
              children: [
                ListRecordTile(
                  title: '${selectedCustomers.length} customers selected',
                  subtitle: selectedCustomers
                      .map((customer) => customer.name)
                      .take(3)
                      .join(', '),
                  note: selectedCustomers.length > 3
                      ? '${selectedCustomers.length - 3} more selected customer(s)'
                      : null,
                ),
                AppDropdownField<String?>(
                  label: 'Collector',
                  value: assignedCollectorId,
                  items: [
                    null,
                    ..._repository.listCollectors().map((collector) {
                      return collector.id;
                    }),
                  ],
                  itemLabel: _collectorName,
                  onChanged: (value) {
                    setSheetState(() => assignedCollectorId = value);
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
  }

  void _deactivateCustomer(Customer customer) {
    setState(() => _repository.deactivateCustomer(customer.id));
    showAppMessage(context, '${customer.name} deactivated.');
  }

  void _updateSelectedCustomersStatus(AdminRecordStatus status) {
    final selectedCustomers = _selectedCustomers;
    if (selectedCustomers.isEmpty) {
      showAppMessage(context, 'Select at least one customer first.');
      return;
    }

    setState(() {
      for (final customer in selectedCustomers) {
        _repository.updateCustomer(customer.copyWith(status: status));
      }
    });
    showAppMessage(
      context,
      '${selectedCustomers.length} customer(s) marked ${status.label.toLowerCase()}.',
    );
  }

  void _setSelectedCustomersQrGenerated(bool qrGenerated) {
    final selectedCustomers = _selectedCustomers;
    if (selectedCustomers.isEmpty) {
      showAppMessage(context, 'Select at least one customer first.');
      return;
    }

    setState(() {
      for (final customer in selectedCustomers) {
        _repository.setCustomerQrGenerated(customer.id, qrGenerated);
      }
    });
    showAppMessage(
      context,
      qrGenerated
          ? 'QR generated for ${selectedCustomers.length} customer(s).'
          : 'QR reset for ${selectedCustomers.length} customer(s).',
    );
  }

  Future<void> _deleteCustomer(Customer customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove customer?'),
          content: Text('${customer.name} will be removed from this list.'),
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
      _repository.deleteCustomer(customer.id);
      _selectedCustomerIds.remove(customer.id);
    });
    showAppMessage(context, '${customer.name} removed.');
  }

  Future<void> _deleteSelectedCustomers() async {
    final selectedCustomers = _selectedCustomers;
    if (selectedCustomers.isEmpty) {
      showAppMessage(context, 'Select at least one customer first.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove selected customers?'),
          content: Text(
            '${selectedCustomers.length} selected customer(s) will be removed from this list.',
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
      for (final customer in selectedCustomers) {
        _repository.deleteCustomer(customer.id);
      }
      _syncCustomerSelection();
    });
    showAppMessage(context, '${selectedCustomers.length} customer(s) removed.');
  }

  @override
  Widget build(BuildContext context) {
    final customers = _filteredCustomers;
    final selectedCount = _selectedCustomers.length;
    final activeCount = _repository
        .listCustomers()
        .where((customer) => customer.status == AdminRecordStatus.active)
        .length;

    return AppScreen(
      theme: ScreenThemeVariant.admin,
      title: 'Manage Customers Screen',
      backLabel: 'Admin Dashboard',
      backRoute: AppRoutes.adminDashboard,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              SectionHeader(
                title: 'Customers',
                subtitle:
                    '$activeCount active of ${_repository.listCustomers().length} total',
                trailing: SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () => _showCustomerForm(),
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
                      hintText: 'Name, phone, address, meter',
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
                          ? 'Select one or more customers to run batch actions.'
                          : '$selectedCount customer(s) selected',
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
                            onPressed: _selectAllVisibleCustomers,
                          ),
                        ),
                        AppActionButton(
                          action: AppAction(
                            'Clear Selection',
                            icon: Icons.deselect_rounded,
                            tiny: true,
                            onPressed: _clearCustomerSelection,
                          ),
                        ),
                        if (selectedCount > 0) ...[
                          AppActionButton(
                            action: AppAction(
                              'Mark Active',
                              icon: Icons.check_circle_rounded,
                              tiny: true,
                              onPressed: () => _updateSelectedCustomersStatus(
                                AdminRecordStatus.active,
                              ),
                            ),
                          ),
                          AppActionButton(
                            action: AppAction(
                              'Deactivate',
                              tiny: true,
                              onPressed: () => _updateSelectedCustomersStatus(
                                AdminRecordStatus.inactive,
                              ),
                            ),
                          ),
                          AppActionButton(
                            action: AppAction(
                              'Assign Collector',
                              tiny: true,
                              onPressed: _assignCollectorToSelectedCustomers,
                            ),
                          ),
                          AppActionButton(
                            action: AppAction(
                              'Generate QR',
                              icon: Icons.qr_code_rounded,
                              tiny: true,
                              onPressed: () =>
                                  _setSelectedCustomersQrGenerated(true),
                            ),
                          ),
                          AppActionButton(
                            action: AppAction(
                              'Reset QR',
                              icon: Icons.qr_code_2_rounded,
                              tiny: true,
                              onPressed: () =>
                                  _setSelectedCustomersQrGenerated(false),
                            ),
                          ),
                          AppActionButton(
                            action: AppAction(
                              'Remove Selected',
                              danger: true,
                              tiny: true,
                              onPressed: _deleteSelectedCustomers,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (customers.isEmpty)
                const EmptyStateCard(
                  title: 'No customers found',
                  message: 'Adjust the search or add a new customer.',
                )
              else
                ...customers.map((customer) {
                  final collectorName = _collectorName(
                    customer.assignedCollectorId,
                  );
                  return ListRecordTile(
                    title: customer.name,
                    subtitle:
                        '${customer.phone} | ${customer.address} | ${customer.meterNumber}',
                    headerTrailing: Checkbox.adaptive(
                      value: _selectedCustomerIds.contains(customer.id),
                      onChanged: (value) {
                        _toggleCustomerSelection(customer.id, value ?? false);
                      },
                    ),
                    extra: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          AppChip('Status: ${customer.status.label}'),
                          AppChip(
                            'QR: ${customer.qrGenerated ? 'Generated' : 'Not Generated'}',
                          ),
                          AppChip('Collector: $collectorName'),
                        ],
                      ),
                    ],
                    actions: [
                      AppAction(
                        'Edit',
                        onPressed: () => _showCustomerForm(customer: customer),
                      ),
                      AppAction(
                        'Assign',
                        onPressed: () => _assignCollector(customer),
                      ),
                      AppAction(
                        customer.qrGenerated ? 'Reset QR' : 'Generate QR',
                        onPressed: () {
                          setState(() {
                            _repository.setCustomerQrGenerated(
                              customer.id,
                              !customer.qrGenerated,
                            );
                          });
                          showAppMessage(context, 'QR status updated.');
                        },
                      ),
                      AppAction(
                        'Deactivate',
                        onPressed: () => _deactivateCustomer(customer),
                      ),
                      AppAction(
                        'Remove',
                        danger: true,
                        onPressed: () => _deleteCustomer(customer),
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
