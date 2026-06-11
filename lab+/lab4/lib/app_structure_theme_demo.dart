import 'package:flutter/material.dart';

// This screen demonstrates Scaffold, AppBar, Body,
// FloatingActionButton, and theme control.
class AppStructureThemeDemo extends StatelessWidget {
  // Current dark mode value received from main.dart.
  final bool darkMode;

  // Function received from main.dart to change dark mode.
  final ValueChanged<bool> onDarkModeChanged;

  const AppStructureThemeDemo({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is the top bar.
      appBar: AppBar(
        title: const Text('Exercise 4 - App Structure & Theme'),

        // actions places widgets on the right side of AppBar.
        actions: [
          const Center(child: Text('Dark')),

          // Switch controls dark mode.
          Switch(
            value: darkMode,

            // When switch changes, call the function from main.dart.
            onChanged: onDarkModeChanged,
          ),
        ],
      ),

      // Body is the main content of the screen.
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'This screen uses Scaffold, AppBar, Body, FloatingActionButton, and ThemeData.',
            textAlign: TextAlign.center,
          ),
        ),
      ),

      // FloatingActionButton is the circular button at the bottom-right.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Empty for this exercise.
          // You can add an action here if needed.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
