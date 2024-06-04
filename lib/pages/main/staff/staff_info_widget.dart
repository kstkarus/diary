import 'package:flutter/material.dart';
import '../../../utils/http_parser.dart';
import '../../../utils/schedule_list.dart';

class StaffInfoPage extends StatelessWidget {
  const StaffInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments["name"]),
      ),
      body: FutureBuilder(
        future: getStaffSchedule(arguments["login"]),
        builder: (context, v) {
          if (v.hasData) {
            return ScheduleList(
                schedule: v.data!,
            );
          } else if (v.hasError) {
            return Text("An error occurred: ${v.error}");
          }

          return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
