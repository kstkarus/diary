import 'package:date_picker_timeline/extra/style.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';
import 'http_parser.dart' as http_manager;

class Schedule extends StatefulWidget {
  Schedule({
    super.key,
    this.id = "5116", // эээ ватахе
    this.count = 14,
  }) {
    scheduleFuture = http_manager.getSchedule(id);
  }

  final String id;
  final DateTime from = DateTime.now();
  final int count;

  late final Future<Map<String, dynamic>> scheduleFuture;

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final DatePickerController _dateController = DatePickerController();
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildEasyDateTimeLine(context),
        FutureBuilder(
          future: widget.scheduleFuture,
          builder: (context, v) {
            if (v.hasData) {
              return Expanded(
                child: PageView(
                  onPageChanged: (int pageNumber) {
                    setState(() {
                      _dateController.setDateAndAnimate(
                          widget.from.add(Duration(days: pageNumber)),
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 300),
                      );
                    });
                  },
                  controller: _pageController,
                  children: buildSchedulePages(v.data),
                ),
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  bool isShouldDisplay(String type, DateTime date) {
    bool parity = date.weekNumber % 2 == 0;
    int groupType = 1; // не выбрана

    switch (type) {
      case "":
        return true;
      case "неч":
        return !parity;
      case "чет":
        return parity;
      case "неч/чет":
        if (groupType == 1) {
          return !parity;
        }
        if (groupType == 2) {
          return parity;
        }
        return true;
      case "чет/неч":
        if (groupType == 1) {
          return parity;
        }
        if (groupType == 2) {
          return !parity;
        }
        return true;
      default:
        String currentDate = DateFormat('dd.MM').format(date);

        String infoSpaceless = type.replaceAll(" ", "");
        List<String> groups = infoSpaceless.split("/");

        if (groupType == 0) { // если подгруппа не выбрана, то проходим по каждой дате
          for (int i = 0; i < groups.length; i++) {
            String group = groups[i];

            for (var j in group.split(";")) {
              if (currentDate == j) {
                return true;
              }
            }
          }
        } else {
          String group = groups[groupType - 1]; // если подгруппа выбрана, то проходим до/после слеша

          for (var j in group.split(";")) {
            if (currentDate == j) {
              return true;
            }
          }
        }
    }

    return false;
  }

  List<Widget> buildSchedulePages(Map<String, dynamic>? schedule) {
    List<Widget> buffer = [];

    if (schedule != null) {
      for (int i = 0; i < widget.count; i++) {
        DateTime dayCurrent = widget.from.add(Duration(days: i));
        var scheduleCurrent = schedule[dayCurrent.weekday.toString()];

        if (scheduleCurrent != null) {
          buffer.add(
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: scheduleCurrent.length,
                  itemBuilder: (context, j) {
                    var data = scheduleCurrent[j];

                    bool shouldDiplay = isShouldDisplay(
                      data["dayDate"].trim(),
                      dayCurrent
                    );

                    return shouldDiplay
                        ? Card(
                            child: ListTile(
                              title: Text(
                                data["disciplName"].trim(),
                              ),
                              subtitle: Wrap(
                                spacing: 10,
                                children: [
                                  Text(data["dayTime"].trim()),
                                  Text(data['buildNum'].trim()),
                                  Text(data["audNum"].trim()),
                                  Text(data["disciplType"].trim()),
                                  Text(data["dayDate"].trim()),
                                  Text(data["prepodName"].trim()),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }
              )
          );
        } else {
          buffer.add(
              const Center(child: Text("Unable to get schedule for this date"))
          );
        }
      }
    }

    return buffer;
  }

  Widget buildCard(var data) {
    return Card(
      child: ListTile(
        title: Text(data["disciplName"]),
        subtitle: Wrap(
          spacing: 150,
          children: [
            Text(data["dayTime"].trim()),
            Text(data['buildNum'].trim()),
            Text(data["audNum"].trim()),
            Text(data["disciplType"].trim()),
            Text(data["dayDate"].trim()),
            Text(data["prepodName"].trim()),
          ],
        ),
      ),
    );
  }

  DatePicker buildEasyDateTimeLine(BuildContext context) {
    return DatePicker(
      widget.from,
      controller: _dateController,
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
      initialSelectedDate: widget.from,
      onDateChange: (selectedDate) {
        setState(() {
          _pageController.animateToPage(
              selectedDate.ordinalDate - widget.from.ordinalDate,
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeInOut
          );
        });
      },
    );
  }
}