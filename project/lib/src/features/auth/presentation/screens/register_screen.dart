import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../application/demo_auth_store.dart';
import '../../../../core/widgets/app_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    showAppMessage(context, 'Registration form cleared.');
  }

  void _register() {
    final result = DemoAuthStore.register(
      fullName: _fullNameController.text,
      identifier: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
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
      title: 'Register Screen',
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
                      'Create account',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    AppField(
                      label: 'Full Name',
                      hintText: 'Enter full name',
                      controller: _fullNameController,
                    ),
                    ResponsiveGrid(
                      children: [
                        AppField(
                          label: 'Email',
                          hintText: 'name@example.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        AppField(
                          label: 'Phone',
                          hintText: '09xx xxx xxxx',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    AppField(
                      label: 'Password',
                      hintText: 'Create password',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    AppField(
                      label: 'Confirm Password',
                      hintText: 'Confirm password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  AppAction(
                    'Create Account',
                    onPressed: _register,
                    primary: true,
                  ),
                  AppAction(
                    'Back to Login',
                    route: AppRoutes.login,
                    replaceRoute: true,
                  ),
                ],
              ),
              ActionBar(
                actions: [AppAction('Clear Form', onPressed: _clearForm)],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
