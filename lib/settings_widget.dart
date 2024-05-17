import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setInt("groupID", 0);
              },
              child: const Text("Reset group")
          )
        ],
      ),
    );
  }
}
