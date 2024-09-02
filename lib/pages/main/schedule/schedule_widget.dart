import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/schedule_class.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({
    super.key,
    required this.schedule,
  });

  final Map<String, dynamic> schedule;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, prefs) {
        if (prefs.hasData) {
          return Schedule(
            schedule: widget.schedule,
            sorting: prefs.data!.getBool("groupSorting") ?? true,
            groupType: prefs.data!.getInt("groupType") ?? 0,
          );
        }

        return const LinearProgressIndicator();
      },
    );
  }
}
