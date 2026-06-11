import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Lab10FullApp());
}

class StoredSession {
  final String displayName;
  final String email;
  final String token;
  final String provider;

  const StoredSession({
    required this.displayName,
    required this.email,
    required this.token,
    required this.provider,
  });
}

class SessionStore {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  static const String displayNameKey = 'display_name';
  static const String emailKey = 'email';
  static const String tokenKey = 'token';
  static const String providerKey = 'provider';

  Future<void> saveSession(StoredSession session) async {
    await prefs.setString(displayNameKey, session.displayName);
    await prefs.setString(emailKey, session.email);
    await prefs.setString(tokenKey, session.token);
    await prefs.setString(providerKey, session.provider);
  }

  Future<StoredSession?> readSession() async {
    final String? displayName = await prefs.getString(displayNameKey);
    final String? email = await prefs.getString(emailKey);
    final String? token = await prefs.getString(tokenKey);
    final String? provider = await prefs.getString(providerKey);

    if (displayName == null ||
        email == null ||
        token == null ||
        provider == null) {
      return null;
    }

    return StoredSession(
      displayName: displayName,
      email: email,
      token: token,
      provider: provider,
    );
  }

  Future<void> clearSession() async {
    await prefs.remove(displayNameKey);
    await prefs.remove(emailKey);
    await prefs.remove(tokenKey);
    await prefs.remove(providerKey);
  }
}

class ApiLoginResult {
  final String displayName;
  final String email;
  final String token;

  const ApiLoginResult({
    required this.displayName,
    required this.email,
    required this.token,
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
      email: json['email'] as String? ?? '${json['username']}@dummyjson.local',
      token: (json['accessToken'] ?? json['token']) as String,
    );
  }

  void dispose() {
    client.close();
  }
}

class NotificationService {
  static const String channelId = 'lab10_full_channel';
  static const String channelName = 'Lab 10 Full Notifications';
  static const String channelDescription =
      'Notifications used after successful login';

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await plugin.initialize(settings: settings);

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.max,
      ),
    );
  }

  Future<void> requestPermission() async {
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> showLoginSuccess(String displayName) async {
    await plugin.show(
      id: 10,
      title: 'Login successful',
      body: 'Welcome back, $displayName',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_launcher',
        ),
      ),
    );
  }
}

class Lab10FullApp extends StatefulWidget {
  const Lab10FullApp({super.key});

  @override
  State<Lab10FullApp> createState() => _Lab10FullAppState();
}

class _Lab10FullAppState extends State<Lab10FullApp> {
  final SessionStore sessionStore = SessionStore();
  final DummyJsonAuthService authService = DummyJsonAuthService();
  final NotificationService notificationService = NotificationService();
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  StreamSubscription<GoogleSignInAuthenticationEvent>? authSubscription;

  StoredSession? currentSession;
  bool isCheckingApp = true;
  bool isGoogleBusy = false;
  bool firebaseReady = false;
  String googleStatus = '';

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    authService.dispose();
    super.dispose();
  }

  Future<void> initializeApp() async {
    await notificationService.initialize();
    await notificationService.requestPermission();

    final StoredSession? savedSession = await sessionStore.readSession();

    try {
      await Firebase.initializeApp();
      firebaseReady = true;
      googleStatus = 'Firebase ready.';
    } catch (_) {
      googleStatus =
          'Firebase is not configured. Google Sign-In will show a setup message.';
    }

    await googleSignIn.initialize();
    authSubscription = googleSignIn.authenticationEvents.listen(
      handleGoogleEvent,
      onError: handleGoogleError,
    );

    if (savedSession?.provider == 'google') {
      final Future<GoogleSignInAccount?>? restoreAttempt = googleSignIn
          .attemptLightweightAuthentication();
      if (restoreAttempt != null) {
        try {
          await restoreAttempt;
        } catch (_) {
          // The listener updates the visible status message.
        }
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      currentSession = savedSession;
      isCheckingApp = false;
    });
  }

  Future<void> loginWithApi({
    required String username,
    required String password,
  }) async {
    final ApiLoginResult result = await authService.login(
      username: username,
      password: password,
    );

    final StoredSession session = StoredSession(
      displayName: result.displayName,
      email: result.email,
      token: result.token,
      provider: 'api',
    );

    await sessionStore.saveSession(session);
    await notificationService.showLoginSuccess(session.displayName);

    if (!mounted) {
      return;
    }

    setState(() {
      currentSession = session;
    });
  }

  Future<void> startGoogleSignIn() async {
    if (isGoogleBusy) {
      return;
    }

    if (!firebaseReady) {
      if (!mounted) {
        return;
      }

      setState(() {
        googleStatus =
            'Firebase setup is missing. Add google-services.json or run flutterfire configure first.';
      });
      return;
    }

    if (!googleSignIn.supportsAuthenticate()) {
      if (!mounted) {
        return;
      }

      setState(() {
        googleStatus =
            'This platform does not support authenticate(). Use Android for this lab.';
      });
      return;
    }

    setState(() {
      isGoogleBusy = true;
      googleStatus = 'Opening Google Sign-In...';
    });

    try {
      await googleSignIn.authenticate();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isGoogleBusy = false;
        googleStatus = 'Google Sign-In failed: $error';
      });
    }
  }

  Future<void> handleGoogleEvent(GoogleSignInAuthenticationEvent event) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (user == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        isGoogleBusy = false;
        googleStatus = 'Google user signed out.';
      });
      return;
    }

    try {
      final String? idToken = user.authentication.idToken;
      if (idToken == null) {
        throw Exception('No Google ID token was returned.');
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );
      final UserCredential firebaseResult = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User firebaseUser = firebaseResult.user!;
      final StoredSession session = StoredSession(
        displayName:
            firebaseUser.displayName ?? user.displayName ?? 'Google User',
        email: firebaseUser.email ?? user.email,
        token: 'google:${firebaseUser.uid}',
        provider: 'google',
      );

      await sessionStore.saveSession(session);
      await notificationService.showLoginSuccess(session.displayName);

      if (!mounted) {
        return;
      }

      setState(() {
        currentSession = session;
        isGoogleBusy = false;
        googleStatus = 'Google Sign-In successful.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isGoogleBusy = false;
        googleStatus = 'Google Sign-In failed: $error';
      });
    }
  }

  void handleGoogleError(Object error) {
    if (!mounted) {
      return;
    }

    setState(() {
      isGoogleBusy = false;
      googleStatus = 'Google Sign-In failed: $error';
    });
  }

  Future<void> logout() async {
    await sessionStore.clearSession();

    if (firebaseReady) {
      await FirebaseAuth.instance.signOut();
    }

    try {
      await googleSignIn.signOut();
    } catch (_) {
      // API users may not have a Google session, so sign-out errors can be ignored here.
    }

    if (!mounted) {
      return;
    }

    setState(() {
      currentSession = null;
      googleStatus = 'Logged out.';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (isCheckingApp) {
      home = const SplashScreen();
    } else if (currentSession == null) {
      home = LoginScreen(
        onApiLogin: loginWithApi,
        onGoogleLogin: startGoogleSignIn,
        isGoogleBusy: isGoogleBusy,
        googleStatus: googleStatus,
      );
    } else {
      home = HomeScreen(session: currentSession!, onLogout: logout);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10 Full',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D4ED8)),
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
            Text('Loading Lab 10 Full...'),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Future<void> Function({
    required String username,
    required String password,
  })
  onApiLogin;
  final Future<void> Function() onGoogleLogin;
  final bool isGoogleBusy;
  final String googleStatus;

  const LoginScreen({
    super.key,
    required this.onApiLogin,
    required this.onGoogleLogin,
    required this.isGoogleBusy,
    required this.googleStatus,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController(
    text: 'emilys',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'emilyspass',
  );

  bool isApiLoading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submitApiLogin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isApiLoading = true;
    });

    try {
      await widget.onApiLogin(
        username: usernameController.text.trim(),
        password: passwordController.text,
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
          isApiLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10 Full Login')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Text(
              'Real API login + optional Google Sign-In + notification after success.',
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
                onPressed: isApiLoading ? null : submitApiLogin,
                child: isApiLoading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Text('Login with DummyJSON'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: widget.isGoogleBusy ? null : widget.onGoogleLogin,
                icon: const Icon(Icons.account_circle_outlined),
                label: const Text('Sign in with Google'),
              ),
            ),
            const SizedBox(height: 12),
            Text(widget.googleStatus),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final StoredSession session;
  final Future<void> Function() onLogout;

  const HomeScreen({super.key, required this.session, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10 Full Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Welcome, ${session.displayName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Email: ${session.email}'),
          const SizedBox(height: 8),
          Text('Provider: ${session.provider}'),
          const SizedBox(height: 8),
          Text('Token: ${session.token}'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onLogout, child: const Text('Logout')),
        ],
      ),
    );
  }
}
