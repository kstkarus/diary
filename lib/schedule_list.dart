import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:week_number/iso.dart';

bool getWeekParity(DateTime date) {
  return date.weekNumber % 2 == 0;
}

bool validateLesson(String info, bool parity, DateTime date) {
  info = info.trim();

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
      String currentDate = DateFormat('dd.MM').format(date);

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

String convertString(String info, bool parity, DateTime date) {
  String firstTemplate = "1 группа";
  String secondTemplate = "2 группа";

  if (info.length == 7) {
    info = info.substring(0, 3);

    switch (info) {
      case "неч":
        info = !parity ? firstTemplate : secondTemplate;
        break;
      case "чет":
        info = parity ? firstTemplate : secondTemplate;
        break;
    }
  } else if (info.length > 7) {
    String currentDate = DateFormat('dd.MM').format(date);

    String infoSpaceless = info.replaceAll(" ", "");
    List<String> groups = infoSpaceless.split("/");

    for(int i = 0; i < groups.length; i++) {
      for(var j in groups[i].split(";")) {
        if (currentDate == j) {
          info = i == 0 ? firstTemplate : secondTemplate;
          return info;
        }
      }
    }
  }

  return info;
}

class ScheduleList extends StatefulWidget {
  const ScheduleList({
    super.key,
    required this.schedule,
  });

  final Map<String, dynamic> schedule;

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  int index = DateTime.now().weekday;
  bool parity = getWeekParity(DateTime.now());
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    bool isNull = widget.schedule[index.toString()] != null;

    return Column(
      children: [
        buildEasyDateTimeLine(context),
        const SizedBox(height: 10),
        isNull ? Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: (widget.schedule[index.toString()] as List<dynamic>).length,
              itemBuilder: (context, i) {
                if (validateLesson(widget.schedule[index.toString()][i]["dayDate"], parity, date)) { // проверка на чет/нечет
                  return buildInfoTile(widget.schedule[index.toString()][i]);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ) : const Expanded(child: Center(child: Text("There's nothing here..."))),
      ],
    );
  }

  Widget buildInfoTile(Map<String, dynamic> data) {
    return Card(
      child: ListTile(
        title: Text(data["disciplName"]),
        subtitle: Wrap(
          spacing: 10,
          children: [
            Text(data["dayTime"].trim()),
            Text(data['buildNum'].trim()),
            Text(data["audNum"].trim()),
            Text(data["disciplType"].trim()),
            Text(
              convertString(
                data["dayDate"].trim(),
                parity,
                date,
              )
            ),
            Text((data["prepodName"] ?? data["group"]).trim()),
          ],
        ),
      ),
    );
  }

  EasyDateTimeLine buildEasyDateTimeLine(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        setState(() {
          index = selectedDate.weekday;
          parity = getWeekParity(selectedDate);
          date = selectedDate;
        });
      },
      headerProps: const EasyHeaderProps(
        showHeader: false,
      ),
      dayProps: const EasyDayProps(
        activeDayStyle: DayStyle(
          borderRadius: 32.0,
        ),
        inactiveDayStyle: DayStyle(
          borderRadius: 32.0,
        ),
      ),
      timeLineProps: const EasyTimeLineProps(
        hPadding: 16.0, // padding from left and right
        //separatorPadding: 16.0, // padding between days
      ),
    );
  }
}
