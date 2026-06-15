import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../application/demo_auth_store.dart';
import '../../../../core/widgets/app_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final result = DemoAuthStore.login(
      identifier: _identifierController.text,
      password: _passwordController.text,
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
      title: 'Login Screen',
      children: [
        SectionPadding(
          child: Stacked(
            children: [
              AppCard(
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
                    AppField(
                      label: 'Username or Email',
                      hintText: 'Enter login identifier',
                      controller: _identifierController,
                    ),
                    AppField(
                      label: 'Password',
                      hintText: 'Enter password',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              ActionBar(
                actions: [
                  AppAction('Login', onPressed: _login, primary: true),
                  AppAction(
                    'Register',
                    route: AppRoutes.register,
                    replaceRoute: true,
                  ),
                ],
              ),
              ActionBar(
                actions: [
                  AppAction(
                    'Forgot Password',
                    route: AppRoutes.resetPassword,
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
