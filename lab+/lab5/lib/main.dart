// main.dart

import 'package:flutter/material.dart';

// Import the first screen of the app.
import 'home_screen.dart';

void main() {
  // runApp starts the Flutter app.
  runApp(const MovieApp());
}

// Root widget of the application.
class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the debug banner from the top-right corner.
      debugShowCheckedModeBanner: false,

      // App title.
      title: 'Movie Detail App',

      // Basic theme for the app.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // HomeScreen is the first screen shown.
      home: const HomeScreen(),
    );
  }
}
