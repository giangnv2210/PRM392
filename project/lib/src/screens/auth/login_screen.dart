import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'Collector';

  String get _targetRoute => switch (_selectedRole) {
    'Admin' => AppRoutes.adminDashboard,
    _ => AppRoutes.collectorDashboard,
  };

  @override
  Widget build(BuildContext context) {
    return MockupPage(
      theme: ScreenThemeVariant.auth,
      title: 'Login Screen',
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              const MockupCard(
                accent: true,
                child: Stacked(
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    MockField(
                      label: 'Username or Email',
                      hintText: 'Enter login identifier',
                    ),
                    MockField(
                      label: 'Password',
                      hintText: 'Enter password',
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              MockupCard(
                child: MockField(
                  label: 'Preview Role',
                  options: const ['Collector', 'Admin'],
                  dropdownValue: _selectedRole,
                  onDropdownChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedRole = value);
                  },
                ),
              ),
              ActionBar(
                actions: [
                  MockAction('Login', route: _targetRoute, primary: true),
                  const MockAction('Register', route: AppRoutes.register),
                ],
              ),
              const ActionBar(
                actions: [
                  MockAction('Forgot Password', route: AppRoutes.resetPassword),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
