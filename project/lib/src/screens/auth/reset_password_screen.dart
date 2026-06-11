import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../ui/mockup_widgets.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockupPage(
      theme: ScreenThemeVariant.auth,
      title: 'Reset Password Screen',
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
                      'Recover access',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    MockField(
                      label: 'Registered Email or Phone',
                      hintText: 'Enter email or phone',
                    ),
                    MockField(
                      label: 'Verification Code',
                      hintText: 'Enter OTP or reset code',
                    ),
                    MockField(
                      label: 'New Password',
                      hintText: 'Create new password',
                      obscureText: true,
                    ),
                    MockField(
                      label: 'Confirm New Password',
                      hintText: 'Confirm new password',
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  MockAction('Send Code'),
                  MockAction(
                    'Reset Password',
                    route: AppRoutes.login,
                    primary: true,
                  ),
                ],
              ),
              ActionBar(
                actions: [MockAction('Back to Login', route: AppRoutes.login)],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
