import 'package:flutter/material.dart';
import '../../../utils/http_parser.dart' as http_manager;
import '../../../utils/schedule_class.dart';

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
        future: http_manager.getStaffSchedule(
            arguments["login"]
        ),
        builder: (context, v) {
          if (v.hasData) {
            return Schedule(
              schedule: v.data!,
              isStaff: true,
            );
          }

          return const LinearProgressIndicator();
        },
      ),
    );
  }
}
