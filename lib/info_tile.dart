import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.text,
    required this.time,
    required this.room,
    required this.type,
  });

  final String text;
  final String time;
  final String room;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(text),
        subtitle: Wrap(
          spacing: 15,
          children: [
            Text(time.trim()),
            Text(room.trim()),
            Text(type.trim()),
          ],
        ),
      ),
    );
  }
}
