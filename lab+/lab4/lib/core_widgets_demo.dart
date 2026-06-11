import 'package:flutter/material.dart';

// This screen demonstrates basic Flutter display widgets.
// It does not need changing data, so it uses StatelessWidget.
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top bar of the screen.
      appBar: AppBar(title: const Text('Exercise 1 - Core Widgets')),

      // Padding adds space around the content.
      body: Padding(
        padding: const EdgeInsets.all(16),

        // Column places widgets vertically from top to bottom.
        child: Column(
          children: [
            // Text widget displays words on the screen.
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // SizedBox creates empty space between widgets.
            const SizedBox(height: 16),

            // Icon displays a Material Design icon.
            const Icon(Icons.movie, size: 64, color: Colors.blue),

            const SizedBox(height: 16),

            // Image.network loads an image from the internet.
            Image.network('https://picsum.photos/300/180'),

            const SizedBox(height: 16),

            // Card creates a material-style box.
            const Card(
              // ListTile is commonly used for list rows.
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('Movie Item'),
                subtitle: Text('This is a sample ListTile inside a Card'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
