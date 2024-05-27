import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Group { none, first, second }

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Group selection = Group.none;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString("GroupID", "");

                  Navigator.pushNamedAndRemoveUntil(context, "/AuthPage", (_) => false);
                },
                child: const Text("Reset group's num.")
            ),
            const SizedBox(height: 10),
            SegmentedButton<Group>(
              segments: const [
                ButtonSegment<Group>(
                  value: Group.first,
                  label: Text("First"),
                ),
                ButtonSegment<Group>(
                    value: Group.none,
                    label: Text("None"),
                ),
                ButtonSegment<Group>(
                    value: Group.second,
                    label: Text("Second"),
                ),
              ],
              selected: {selection},
              onSelectionChanged: (newSelection) {
                selection = newSelection.first;
              },
            ),
          ],
        ),
      ),
    );
  }
}
