import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Group { none, first, second }

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            GroupButton(),
          ],
        ),
      ),
    );
  }
}

class GroupButton extends StatefulWidget {
  const GroupButton({
    super.key,
  });

  @override
  State<GroupButton> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  late final Future<SharedPreferences> prefs;
  late int selection;

  @override
  void initState() {
    super.initState();

    prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefs,
      builder: (context, v) {
        if (v.hasData) {
          selection = v.data!.getInt("groupType") ?? 0;

          return SegmentedButton<int>(
            segments: const [
              ButtonSegment<int>(
                value: 1,
                label: Text("First"),
              ),
              ButtonSegment<int>(
                value: 0,
                label: Text("None"),
              ),
              ButtonSegment<int>(
                value: 2,
                label: Text("Second"),
              ),
            ],
            selected: {selection},
            onSelectionChanged: (newSelection) async {
              setState(() {
                selection = newSelection.first;
              });

              final prefs = await SharedPreferences.getInstance();
              prefs.setInt("groupType", newSelection.first);
            },
          );
        }

        return const Text("Wait till loading...");
      }
    );
  }
}
