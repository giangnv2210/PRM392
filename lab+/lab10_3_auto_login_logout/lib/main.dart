import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AutoLoginApp());
}

class StoredSession {
  final String username;
  final String displayName;
  final String token;

  const StoredSession({
    required this.username,
    required this.displayName,
    required this.token,
  });
}

class DummyJsonAuthService {
  final http.Client client;

  DummyJsonAuthService({http.Client? client})
    : client = client ?? http.Client();

  Future<StoredSession> login({
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

    return StoredSession(
      username: json['username'] as String,
      displayName: '$firstName $lastName'.trim(),
      token: (json['accessToken'] ?? json['token']) as String,
    );
  }

  void dispose() {
    client.close();
  }
}

class SessionStore {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  static const String usernameKey = 'username';
  static const String displayNameKey = 'display_name';
  static const String tokenKey = 'token';

  Future<void> saveSession(StoredSession session) async {
    await prefs.setString(usernameKey, session.username);
    await prefs.setString(displayNameKey, session.displayName);
    await prefs.setString(tokenKey, session.token);
  }

  Future<StoredSession?> readSession() async {
    final String? username = await prefs.getString(usernameKey);
    final String? displayName = await prefs.getString(displayNameKey);
    final String? token = await prefs.getString(tokenKey);

    if (username == null || displayName == null || token == null) {
      return null;
    }

    return StoredSession(
      username: username,
      displayName: displayName,
      token: token,
    );
  }

  Future<void> clearSession() async {
    await prefs.remove(usernameKey);
    await prefs.remove(displayNameKey);
    await prefs.remove(tokenKey);
  }
}

class AutoLoginApp extends StatefulWidget {
  const AutoLoginApp({super.key});

  @override
  State<AutoLoginApp> createState() => _AutoLoginAppState();
}

class _AutoLoginAppState extends State<AutoLoginApp> {
  final SessionStore sessionStore = SessionStore();
  late final DummyJsonAuthService authService;

  StoredSession? currentSession;
  bool isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    authService = DummyJsonAuthService();
    restoreSession();
  }

  @override
  void dispose() {
    authService.dispose();
    super.dispose();
  }

  Future<void> restoreSession() async {
    final StoredSession? savedSession = await sessionStore.readSession();

    if (!mounted) {
      return;
    }

    setState(() {
      currentSession = savedSession;
      isCheckingSession = false;
    });
  }

  Future<void> handleLogin(StoredSession session) async {
    await sessionStore.saveSession(session);

    if (!mounted) {
      return;
    }

    setState(() {
      currentSession = session;
    });
  }

  Future<void> logout() async {
    await sessionStore.clearSession();

    if (!mounted) {
      return;
    }

    setState(() {
      currentSession = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (isCheckingSession) {
      home = const SplashScreen();
    } else if (currentSession == null) {
      home = AutoLoginScreen(
        authService: authService,
        onLoginSuccess: handleLogin,
      );
    } else {
      home = SessionHomeScreen(session: currentSession!, onLogout: logout);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.3 Auto Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Checking saved session...'),
          ],
        ),
      ),
    );
  }
}

class AutoLoginScreen extends StatefulWidget {
  final DummyJsonAuthService authService;
  final Future<void> Function(StoredSession session) onLoginSuccess;

  const AutoLoginScreen({
    super.key,
    required this.authService,
    required this.onLoginSuccess,
  });

  @override
  State<AutoLoginScreen> createState() => _AutoLoginScreenState();
}

class _AutoLoginScreenState extends State<AutoLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController(
    text: 'emilys',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'emilyspass',
  );

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
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
      final StoredSession session = await widget.authService.login(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );
      await widget.onLoginSuccess(session);
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
      appBar: AppBar(title: const Text('Auto Login & Logout')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Text(
              'Login once, then reopen the app to test auto-login.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionHomeScreen extends StatelessWidget {
  final StoredSession session;
  final Future<void> Function() onLogout;

  const SessionHomeScreen({
    super.key,
    required this.session,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            'Session restored successfully.',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Name: ${session.displayName}'),
          const SizedBox(height: 8),
          Text('Username: ${session.username}'),
          const SizedBox(height: 8),
          Text('Token: ${session.token}'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onLogout, child: const Text('Logout')),
        ],
      ),
    );
  }
}
