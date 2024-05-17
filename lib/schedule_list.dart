import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool validateLesson(String info, bool parity, DateTime date) {
  info = info.trim();
  String currentDate = DateFormat('dd.MM').format(date);

  switch (info) {
    case "":
      return true;
    case "неч":
      return !parity;
    case "чет":
      return parity;
    case "неч/чет":
      return true;
    case "чет/неч":
      return true;
    default:
      String infoSpaceless = info.replaceAll(" ", "");
      List<String> groups = infoSpaceless.split("/");

      for(var i in groups) {
        for(var j in i.split(";")) {
          if (currentDate == j) {
            return true;
          }
        }
      }

      return false;
  }
}

String convertString(String info, bool parity) {
  if (info.length == 7) {
    info = info.substring(0, 3);

    switch (info) {
      case "неч":
        info = !parity ? "1 группа" : "2 группа";
        break;
      case "чет":
        info = parity ? "1 группа" : "2 группа";
        break;
    }
  }

  return info;
}

class ScheduleList extends StatelessWidget {
  const ScheduleList({
    super.key,
    required this.schedule,
    required this.index,
    required this.parity,
    required this.date,
  });

  final int index;
  final Map<String, dynamic> schedule;
  final bool parity;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return index != 7 ? ListView.builder(
      itemCount: (schedule[index.toString()] as List<dynamic>).length,
      itemBuilder: (context, i) {
        if (validateLesson(schedule[index.toString()][i]["dayDate"], parity, date)) { // проверка на чет/нечет
          return buildInfoTile(i);
        }
        return const SizedBox.shrink();
      },
    ) : const Center(child: Text("Beer time"));
  }

  Widget buildInfoTile(int i) {
    return Card(
      child: ListTile(
        title: Text(schedule[index.toString()][i]["disciplName"]),
        subtitle: Wrap(
          spacing: 15,
          children: [
            Text(schedule[index.toString()][i]["dayTime"].trim()),
            Text(schedule[index.toString()][i]["audNum"].trim()),
            Text(schedule[index.toString()][i]["disciplType"].trim()),
            Text(
                convertString(schedule[index.toString()][i]["dayDate"].trim(), parity)
            ),
          ],
        ),
      ),
    );
  }
}
