import 'package:flutter/material.dart';

// This screen demonstrates fixes for common Flutter UI errors.
class UiFixesDemo extends StatefulWidget {
  const UiFixesDemo({super.key});

  @override
  State<UiFixesDemo> createState() => _UiFixesDemoState();
}

class _UiFixesDemoState extends State<UiFixesDemo> {
  // Used to demonstrate setState().
  int counter = 0;

  // Used to demonstrate DatePicker with valid context.
  DateTime? pickedDate;

  @override
  Widget build(BuildContext context) {
    final movies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 - Common UI Fixes')),

      // SingleChildScrollView prevents overflow on small screens.
      // If the content is too tall, the user can scroll.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fix 1: ListView inside Column using Expanded',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              // SizedBox gives this demo area a fixed height.
              SizedBox(
                height: 220,

                // Column contains the ListView.
                child: Column(
                  children: [
                    // Expanded gives ListView available height inside Column.
                    Expanded(
                      child: ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.movie),
                            title: Text(movies[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Fix 2: Overflow fixed using SingleChildScrollView',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'This whole page is wrapped with SingleChildScrollView, so it can scroll on small screens instead of overflowing.',
              ),

              const SizedBox(height: 24),

              const Text(
                'Fix 3: State update fixed using setState()',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text('Counter: $counter'),

              ElevatedButton(
                onPressed: () {
                  // setState tells Flutter to rebuild the UI
                  // after the counter value changes.
                  setState(() {
                    counter++;
                  });
                },
                child: const Text('Increase Counter'),
              ),

              const SizedBox(height: 24),

              const Text(
                'Fix 4: DatePicker called from valid BuildContext',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: () async {
                  // This is called from a button inside the widget tree,
                  // so the BuildContext is valid.
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  // Only update if the user actually selected a date.
                  if (date != null) {
                    setState(() {
                      pickedDate = date;
                    });
                  }
                },
                child: const Text('Pick Date'),
              ),

              Text('Picked date: ${pickedDate?.toString() ?? "None"}'),
            ],
          ),
        ),
      ),
    );
  }
}
