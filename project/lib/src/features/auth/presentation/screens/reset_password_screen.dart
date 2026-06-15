import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../application/demo_auth_store.dart';
import '../../../../core/widgets/app_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _identifierController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendCode() {
    final result = DemoAuthStore.sendResetCode(
      identifier: _identifierController.text,
    );
    showAppMessage(context, result.message);
  }

  void _resetPassword() {
    final result = DemoAuthStore.resetPassword(
      identifier: _identifierController.text,
      code: _codeController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    showAppMessage(context, result.message);
    if (result.isSuccess && result.route != null) {
      openAppRoute(context, result.route!, replaceRoute: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      theme: ScreenThemeVariant.auth,
      title: 'Reset Password Screen',
      backLabel: 'Login Screen',
      backRoute: AppRoutes.login,
      backUsesReplacement: true,
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              AppCard(
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
                    AppField(
                      label: 'Registered Email or Phone',
                      hintText: 'Enter email or phone',
                      controller: _identifierController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppField(
                      label: 'Verification Code',
                      hintText: 'Enter OTP or reset code',
                      controller: _codeController,
                    ),
                    AppField(
                      label: 'New Password',
                      hintText: 'Create new password',
                      controller: _newPasswordController,
                      obscureText: true,
                    ),
                    AppField(
                      label: 'Confirm New Password',
                      hintText: 'Confirm new password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  AppAction('Send Code', onPressed: _sendCode),
                  AppAction(
                    'Reset Password',
                    onPressed: _resetPassword,
                    primary: true,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  AppAction(
                    'Back to Login',
                    route: AppRoutes.login,
                    replaceRoute: true,
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
