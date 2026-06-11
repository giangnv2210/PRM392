import 'package:flutter/material.dart';

void main() {
  runApp(const SignupPracticeApp());
}

class SignupPracticeApp extends StatelessWidget {
  const SignupPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 7 Signup Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7490)),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode fullNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  bool isCheckingEmail = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptedTerms = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  // Validation function for the name field.
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    return null;
  }

  // Validation function for the email field.
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final String email = value.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email';
    }

    return null;
  }

  // Validation function for the password field.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }

    return null;
  }

  // Validation function for the confirm password field.
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  String get passwordStrengthLabel {
    final String password = passwordController.text;

    if (password.length < 8) {
      return 'Weak';
    }

    final bool hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    if (hasDigit && hasUppercase) {
      return 'Strong';
    }

    if (hasDigit) {
      return 'Medium';
    }

    return 'Weak';
  }

  Future<bool> isEmailAvailable(String email) async {
    // Future.delayed simulates calling a server.
    await Future<void>.delayed(const Duration(seconds: 2));
    return !email.trim().toLowerCase().startsWith('taken');
  }

  Future<void> submitForm() async {
    FocusScope.of(context).unfocus();

    final bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms first.')),
      );
      return;
    }

    setState(() {
      isCheckingEmail = true;
    });

    final bool available = await isEmailAvailable(emailController.text);

    if (!mounted) {
      return;
    }

    setState(() {
      isCheckingEmail = false;
    });

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This email is already taken.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Signup successful for ${fullNameController.text.trim()}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tapping outside the form closes the keyboard.
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
        body: SafeArea(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This example keeps the UI simple and shows validation, keyboard flow, and async email checking.',
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: fullNameController,
                  focusNode: fullNameFocus,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateFullName,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(emailFocus);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  focusNode: emailFocus,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateEmail,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(passwordFocus);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  textInputAction: TextInputAction.next,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: validatePassword,
                  onChanged: (_) {
                    // Rebuild to refresh the strength label.
                    setState(() {});
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(confirmPasswordFocus);
                  },
                ),
                const SizedBox(height: 8),
                Text('Password strength: $passwordStrengthLabel'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocus,
                  textInputAction: TextInputAction.done,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: validateConfirmPassword,
                  onFieldSubmitted: (_) {
                    submitForm();
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: acceptedTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      acceptedTerms = value ?? false;
                    });
                  },
                  title: const Text('I accept the Terms & Conditions'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isCheckingEmail ? null : submitForm,
                    child: isCheckingEmail
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tip: try an email like taken_student@example.com to see the fake async check fail.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
