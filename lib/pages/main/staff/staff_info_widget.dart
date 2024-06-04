import 'package:flutter/material.dart';
//import '../../../utils/http_parser.dart';
//import '../../../utils/schedule_list.dart';
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
      body: Schedule(
        id: arguments["login"],
      ),
    );
  }
}
