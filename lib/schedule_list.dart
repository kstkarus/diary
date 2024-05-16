import 'package:flutter/material.dart';
import 'info_tile.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key, required this.schedule, required this.index});

  final int index;
  final Map<String, dynamic> schedule;

  @override
  Widget build(BuildContext context) {
    return index != 7 ? ListView.builder(
      itemCount: (schedule[index.toString()] as List<dynamic>).length,
      itemBuilder: (context, i) {
        return InfoTile(
          text: schedule[index.toString()][i]["disciplName"],
          time: schedule[index.toString()][i]["dayTime"],
          room: schedule[index.toString()][i]["audNum"],
          type: schedule[index.toString()][i]["disciplType"]
        );
      },
    ) : const Center(child: Text("Beer time"));
  }
}
