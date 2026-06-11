import 'package:flutter/material.dart';

// This screen uses input widgets, so it must be StatefulWidget.
// StatefulWidget is used when values on screen can change.
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

// This class stores the changing values for the screen.
class _InputControlsDemoState extends State<InputControlsDemo> {
  // Slider value.
  double rating = 50;

  // Switch value.
  bool active = false;

  // Radio button selected value.
  String genre = 'Action';

  // DatePicker selected date.
  // The ? means it can be null before the user selects a date.
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 - Input Widgets')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          // Align children to the left side.
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rating Slider'),

            // Slider lets the user choose a number by dragging.
            Slider(
              value: rating,
              min: 0,
              max: 100,
              divisions: 100,
              label: rating.round().toString(),

              // onChanged runs whenever the slider is moved.
              onChanged: (value) {
                // setState updates the variable and refreshes the UI.
                setState(() {
                  rating = value;
                });
              },
            ),

            Text('Current value: ${rating.round()}'),

            const SizedBox(height: 16),

            // SwitchListTile is a switch with title and subtitle.
            SwitchListTile(
              title: const Text('Active Switch'),
              subtitle: const Text('Is movie active?'),
              value: active,

              // This runs when the switch is turned on/off.
              onChanged: (value) {
                setState(() {
                  active = value;
                });
              },
            ),

            const SizedBox(height: 16),

            const Text('Genre'),

            // RadioListTile allows choosing one option from a group.
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',

              // groupValue is the currently selected value.
              groupValue: genre,

              // If this option is selected, update genre.
              onChanged: (value) {
                setState(() {
                  genre = value!;
                });
              },
            ),

            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: genre,
              onChanged: (value) {
                setState(() {
                  genre = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Button used to open the DatePicker.
            ElevatedButton(
              onPressed: () async {
                // showDatePicker opens a date picker dialog.
                // await waits until the user chooses a date or cancels.
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                // If user selected a date, update selectedDate.
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: const Text('Open Date Picker'),
            ),

            const SizedBox(height: 16),

            // Display current selected values.
            Text('Selected genre: $genre'),

            // If selectedDate is null, show "None".
            Text('Selected date: ${selectedDate?.toString() ?? "None"}'),
          ],
        ),
      ),
    );
  }
}
