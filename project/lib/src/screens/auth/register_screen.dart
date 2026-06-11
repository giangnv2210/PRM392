import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.auth,
      title: 'Register Screen',
      backLabel: 'Login Screen',
      backRoute: AppRoutes.login,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              MockupCard(
                accent: true,
                child: Stacked(
                  children: [
                    Text(
                      'Create account',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    MockField(label: 'Full Name', hintText: 'Enter full name'),
                    MockGrid(
                      children: [
                        MockField(label: 'Email', hintText: 'name@example.com'),
                        MockField(label: 'Phone', hintText: '09xx xxx xxxx'),
                      ],
                    ),
                    MockField(
                      label: 'Requested Role',
                      options: ['Collector', 'Admin'],
                      dropdownValue: 'Collector',
                    ),
                    MockField(
                      label: 'Password',
                      hintText: 'Create password',
                      obscureText: true,
                    ),
                    MockField(
                      label: 'Confirm Password',
                      hintText: 'Confirm password',
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction(
                    'Create Account',
                    route: AppRoutes.login,
                    primary: true,
                  ),
                  MockAction('Back to Login', route: AppRoutes.login),
                ],
              ),
              ActionBar(actions: [MockAction('Clear Form')]),
            ],
          ),
        ),
      ],
    );
  }
}
