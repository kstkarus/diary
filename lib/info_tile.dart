import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.text, required this.time});

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(text),
        subtitle: Row(
          children: [
            Text(time),
            Text("301"),
          ],
        ),
      ),
    );
  }
}
