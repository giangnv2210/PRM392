import 'package:flutter/material.dart';

// This screen demonstrates layout widgets.
// It uses Column, Row, Padding, SizedBox, and ListView.
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list data for ListView.builder.
    final movies = ['Avatar', 'Inception', 'Interstellar', 'Joker'];

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 - Layout Basics')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        // Column arranges widgets vertically.
        child: Column(
          children: [
            const Text(
              'Now Playing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Row arranges widgets horizontally.
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.movie),
                Text('Movie List'),
                Icon(Icons.star),
              ],
            ),

            const SizedBox(height: 16),

            // Expanded gives ListView available space inside Column.
            // Without Expanded, ListView may cause unbounded height error.
            Expanded(
              child: ListView.builder(
                // Number of items in the list.
                itemCount: movies.length,

                // itemBuilder creates each list item.
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      // movies[index][0] gets the first letter of the movie name.
                      leading: CircleAvatar(child: Text(movies[index][0])),
                      title: Text(movies[index]),
                      subtitle: const Text('Sample description'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
