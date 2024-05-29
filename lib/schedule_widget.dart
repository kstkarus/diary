import 'package:flutter/material.dart';
import 'schedule_list.dart';
import 'http_parser.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    Future<Map<String, dynamic>> schedule = getSchedule(
      arguments["groupID"],
    );

    return FutureBuilder(
        future: schedule,
        builder: (context, v) {
          if (v.hasData) {
              return ScheduleList(
                schedule: v.data!,
              ); // 1 - пн, 2 - вт, ..., 6 - сб
          } else if (v.hasError) {
            return Text("${v.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
