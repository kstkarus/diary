import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
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

  DatePickerController controller = DatePickerController();
  DateTime firstDate = DateTime.now();
  DateTime lastDate = DateTime.now().add(const Duration(days: 13)); // days count - 1
  DateTime focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    bool isNull = widget.schedule[index.toString()] != null;

    return Column(
      children: [
        Text(parity ? "четная" : "нечетная"),
        const SizedBox(height: 10),
        buildEasyDateTimeLine(context),
        const SizedBox(height: 10),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (d) {
              if (d.primaryVelocity! > 0) { // right swipe
                if (focusDate.ordinalDate > firstDate.ordinalDate) {
                  setState(() {
                    focusDate = focusDate.subtract(const Duration(days: 1));
                    parity = getWeekParity(focusDate);
                    index = focusDate.weekday;
                    controller.setDateAndAnimate(focusDate);
                  });
                }
              }

              if (d.primaryVelocity! < 0) { // left swipe
                if (focusDate.ordinalDate < lastDate.ordinalDate) {
                  setState(() {
                    focusDate = focusDate.add(const Duration(days: 1));
                    parity = getWeekParity(focusDate);
                    index = focusDate.weekday;
                    controller.setDateAndAnimate(focusDate);
                  });
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: (isNull ? ListView.builder(
                itemCount: (widget.schedule[index.toString()] as List<dynamic>).length,
                itemBuilder: (context, i) {
                  if (validateLesson(widget.schedule[index.toString()][i]["dayDate"], parity, focusDate)) { // проверка на чет/нечет
                    return buildInfoTile(widget.schedule[index.toString()][i]);
                  }
                  return const SizedBox.shrink();
                },
              ) : const SizedBox.expand()),
            ),
          ),
        ),
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
                focusDate,
              )
            ),
            data["prepodName"] != null // если есть имя преподавателя то выводим кликабельный текст
                ? InkWell(
                  onDoubleTap: () {
                    Navigator.pushNamed(
                        context,
                        "/StaffInfoPage",
                        arguments: {
                          "name": data['prepodName'].trim(),
                          "login": data["prepodLogin"],
                        }
                    );
                  },
                  child: Text(
                      data["prepodName"]
                      .trim()
                  )
                 )
                : Text(data["group"].trim()), // иначе номер группы преподавателя
          ],
        ),
      ),
    );
  }

  DatePicker buildEasyDateTimeLine(BuildContext context) {
    return DatePicker(
      firstDate,
      controller: controller,
      daysCount: 14,
      height: 88,
      selectionColor: Theme.of(context).colorScheme.secondaryContainer,
      selectedTextColor: Theme.of(context).colorScheme.onSecondaryContainer,
      todayColor: Theme.of(context).colorScheme.tertiaryContainer,
      todayTextColor: Theme.of(context).colorScheme.onTertiaryContainer,
      dateTextStyle: defaultDateTextStyle.apply(
        color: Theme.of(context).colorScheme.onBackground
      ),
      dayTextStyle: defaultDayTextStyle.apply(
          color: Theme.of(context).colorScheme.onBackground
      ),
      monthTextStyle: defaultMonthTextStyle.apply(
          color: Theme.of(context).colorScheme.onBackground
      ),
      initialSelectedDate: firstDate,
      onDateChange: (selectedDate) {
        setState(() {
          index = selectedDate.weekday;
          parity = getWeekParity(selectedDate);
          focusDate = selectedDate;
        });
      },
    );
  }
}
