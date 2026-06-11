import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseGoogleSignInApp());
}

class FirebaseGoogleSignInApp extends StatelessWidget {
  const FirebaseGoogleSignInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.4 Firebase Sign-In',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEA4335)),
        useMaterial3: true,
      ),
      home: const FirebaseGoogleSignInScreen(),
    );
  }
}

class FirebaseGoogleSignInScreen extends StatefulWidget {
  const FirebaseGoogleSignInScreen({super.key});

  @override
  State<FirebaseGoogleSignInScreen> createState() =>
      _FirebaseGoogleSignInScreenState();
}

class _FirebaseGoogleSignInScreenState
    extends State<FirebaseGoogleSignInScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  StreamSubscription<GoogleSignInAuthenticationEvent>? authSubscription;
  GoogleSignInAccount? currentGoogleUser;
  User? currentFirebaseUser;

  bool isBusy = true;
  bool firebaseReady = false;
  String statusMessage = 'Preparing Google Sign-In...';

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    super.dispose();
  }

  Future<void> setup() async {
    try {
      await Firebase.initializeApp();
      firebaseReady = true;
      statusMessage = 'Firebase is ready.';
    } catch (error) {
      statusMessage =
          'Firebase is not configured yet. Add google-services.json or run flutterfire configure before testing on a device.';
    }

    await googleSignIn.initialize();
    authSubscription = googleSignIn.authenticationEvents.listen(
      handleAuthenticationEvent,
      onError: handleAuthenticationError,
    );

    final Future<GoogleSignInAccount?>? restoreAttempt = googleSignIn
        .attemptLightweightAuthentication();
    if (restoreAttempt != null) {
      try {
        await restoreAttempt;
      } catch (_) {
        // The stream handler shows the error message, so no extra work is needed here.
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isBusy = false;
    });
  }

  Future<void> handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (user == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        currentGoogleUser = null;
        currentFirebaseUser = null;
        statusMessage = 'Signed out.';
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      currentGoogleUser = user;
      isBusy = true;
      statusMessage = 'Google account selected: ${user.email}';
    });

    await signInToFirebase(user);

    if (!mounted) {
      return;
    }

    setState(() {
      isBusy = false;
    });
  }

  void handleAuthenticationError(Object error) {
    if (!mounted) {
      return;
    }

    setState(() {
      isBusy = false;
      statusMessage = 'Sign-In failed: $error';
    });
  }

  Future<void> signInToFirebase(GoogleSignInAccount user) async {
    if (!firebaseReady) {
      if (!mounted) {
        return;
      }

      setState(() {
        statusMessage =
            'Google account loaded, but Firebase is not configured yet.';
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

      final UserCredential result = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (!mounted) {
        return;
      }

      setState(() {
        currentFirebaseUser = result.user;
        statusMessage =
            'Firebase login success: ${result.user?.email ?? user.email}';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        statusMessage = 'Firebase sign-in failed: $error';
      });
    }
  }

  Future<void> startGoogleSignIn() async {
    if (isBusy) {
      return;
    }

    if (!googleSignIn.supportsAuthenticate()) {
      setState(() {
        statusMessage =
            'This platform does not support authenticate(). Use a supported Android target.';
      });
      return;
    }

    setState(() {
      isBusy = true;
      statusMessage = 'Opening Google Sign-In...';
    });

    try {
      await googleSignIn.authenticate();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isBusy = false;
        statusMessage = 'Sign-In failed: $error';
      });
    }
  }

  Future<void> signOut() async {
    setState(() {
      isBusy = true;
    });

    try {
      if (firebaseReady) {
        await FirebaseAuth.instance.signOut();
      }
      await googleSignIn.signOut();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        statusMessage = 'Sign out failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String googleEmail = currentGoogleUser?.email ?? 'Not signed in';
    final String firebaseEmail =
        currentFirebaseUser?.email ?? 'No Firebase user yet';

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Google Sign-In')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const Text(
            'This lab needs Firebase setup before it can fully sign in.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Code is included here for practice, and the status box explains whether setup is missing.',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Google account: $googleEmail'),
                  const SizedBox(height: 8),
                  Text('Firebase account: $firebaseEmail'),
                  const SizedBox(height: 8),
                  Text(statusMessage),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: isBusy ? null : startGoogleSignIn,
              icon: const Icon(Icons.login),
              label: isBusy
                  ? const Text('Working...')
                  : const Text('Sign in with Google'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed:
                  currentGoogleUser == null && currentFirebaseUser == null
                  ? null
                  : signOut,
              child: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }
}
