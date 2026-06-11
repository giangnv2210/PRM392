import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const RealApiLoginApp());
}

class ApiLoginResult {
  final String displayName;
  final String username;
  final String token;
  final String? imageUrl;

  const ApiLoginResult({
    required this.displayName,
    required this.username,
    required this.token,
    required this.imageUrl,
  });
}

class DummyJsonAuthService {
  final http.Client client;

  DummyJsonAuthService({http.Client? client})
    : client = client ?? http.Client();

  Future<ApiLoginResult> login({
    required String username,
    required String password,
  }) async {
    final Uri url = Uri.parse('https://dummyjson.com/auth/login');
    final http.Response response = await client.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(json['message'] ?? 'Login failed.');
    }

    final String firstName = json['firstName'] as String? ?? '';
    final String lastName = json['lastName'] as String? ?? '';

    return ApiLoginResult(
      displayName: '$firstName $lastName'.trim(),
      username: json['username'] as String,
      token: (json['accessToken'] ?? json['token']) as String,
      imageUrl: json['image'] as String?,
    );
  }

  void dispose() {
    client.close();
  }
}

class RealApiLoginApp extends StatelessWidget {
  const RealApiLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.2 Real API Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED)),
        useMaterial3: true,
      ),
      home: const RealApiLoginScreen(),
    );
  }
}

class RealApiLoginScreen extends StatefulWidget {
  const RealApiLoginScreen({super.key});

  @override
  State<RealApiLoginScreen> createState() => _RealApiLoginScreenState();
}

class _RealApiLoginScreenState extends State<RealApiLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController(
    text: 'emilys',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'emilyspass',
  );
  late final DummyJsonAuthService authService;

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    authService = DummyJsonAuthService();
  }

  @override
  void dispose() {
    authService.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final ApiLoginResult result = await authService.login(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ApiHomeScreen(result: result),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real API Login')),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const Text(
                'Lab 10.2 calls DummyJSON.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Demo username: emilys'),
              const Text('Demo password: emilyspass'),
              const SizedBox(height: 24),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
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
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submit,
                  child: isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Text('Login with API'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApiHomeScreen extends StatelessWidget {
  final ApiLoginResult result;

  const ApiHomeScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            'API login successful.',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (result.imageUrl != null)
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(result.imageUrl!),
            ),
          const SizedBox(height: 16),
          Text('Name: ${result.displayName}'),
          const SizedBox(height: 8),
          Text('Username: ${result.username}'),
          const SizedBox(height: 8),
          Text('Token: ${result.token}'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const RealApiLoginScreen(),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
