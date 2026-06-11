import 'package:flutter/material.dart';

// Import each exercise screen from its own file.
// This lets main.dart open the screens using Navigator.
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_theme_demo.dart';
import 'ui_fixes_demo.dart';

void main() {
  // runApp starts the Flutter application.
  runApp(const MyApp());
}

// MyApp is Stateful because the app needs to remember
// whether dark mode is currently on or off.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// This class stores the state for MyApp.
class _MyAppState extends State<MyApp> {
  // This variable controls whether dark mode is enabled.
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the debug banner at the top-right corner.
      debugShowCheckedModeBanner: false,

      title: 'Lab 4 Flutter UI',

      // Light theme for the app.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),

      // Dark theme for the app.
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Chooses light or dark theme based on the darkMode variable.
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,

      // HomeScreen is the first screen shown when the app starts.
      home: HomeScreen(
        darkMode: darkMode,

        // This function is passed to Exercise 4 so it can change dark mode.
        onDarkModeChanged: (value) {
          setState(() {
            darkMode = value;
          });
        },
      ),
    );
  }
}

// This is the main menu screen.
class HomeScreen extends StatelessWidget {
  final bool darkMode;

  // ValueChanged<bool> means this function receives a boolean value.
  final ValueChanged<bool> onDarkModeChanged;

  const HomeScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  // This helper function opens a new screen.
  void openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is the top bar of the screen.
      appBar: AppBar(title: const Text('Lab 4 - Flutter UI Fundamentals')),

      // ListView creates a scrollable vertical list.
      body: ListView(
        children: [
          ListTile(
            title: const Text('Exercise 1 - Core Widgets'),
            subtitle: const Text('Text, Image, Icon, Card, ListTile'),
            trailing: const Icon(Icons.arrow_forward),

            // When this tile is tapped, open Exercise 1.
            onTap: () {
              openScreen(context, const CoreWidgetsDemo());
            },
          ),

          ListTile(
            title: const Text('Exercise 2 - Input Widgets'),
            subtitle: const Text('Slider, Switch, RadioListTile, DatePicker'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              openScreen(context, const InputControlsDemo());
            },
          ),

          ListTile(
            title: const Text('Exercise 3 - Layout Basics'),
            subtitle: const Text('Column, Row, Padding, ListView'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              openScreen(context, const LayoutDemo());
            },
          ),

          ListTile(
            title: const Text('Exercise 4 - Scaffold and Theme'),
            subtitle: const Text('Scaffold, AppBar, FAB, ThemeData'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              openScreen(
                context,
                AppStructureThemeDemo(
                  darkMode: darkMode,
                  onDarkModeChanged: onDarkModeChanged,
                ),
              );
            },
          ),

          ListTile(
            title: const Text('Exercise 5 - Common UI Fixes'),
            subtitle: const Text('Expanded, ScrollView, setState, DatePicker'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              openScreen(context, const UiFixesDemo());
            },
          ),
        ],
      ),
    );
  }
}
