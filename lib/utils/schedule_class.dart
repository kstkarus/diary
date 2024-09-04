import 'package:date_picker_timeline/extra/style.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';

class Schedule extends StatefulWidget {
  Schedule({
    super.key,
    required this.schedule,
    this.sorting = true,
    this.groupType = 0,
    this.count = 14,
    this.isStaff = false,
  });

  final bool sorting;
  final int groupType;
  final bool isStaff;
  final Map<String, dynamic> schedule;
  final DateTime from = DateTime.now(); // начальная дата
  final int count; // кол-во дней для отображения

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
        buildGroupNum(),
        buildEasyDateTimeLine(context),
        Expanded(
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
            children: buildSchedulePages(widget.schedule),
          ),
        ),
      ],
    );
  }

  Widget buildGroupNum() {
    switch (widget.groupType) {
      case 1:
        return const Text("первая подгруппа");
      case 2:
        return const Text("вторая подгруппа");
      default:
        return const SizedBox.shrink();
    }
  }

  (bool, String) isShouldDisplay(String type, DateTime date, int groupType) {
    bool parity = date.weekNumber % 2 == 0;
    const String templateFirst = "1 группа";
    const String templateSecond = "2 группа";
    // 0 - не выбрана; 1 - первая; 2 - вторая

    switch (type) {
      case "":
        return (true, type);
      case "неч":
        return (!parity, type);
      case "чет":
        return (parity, type);
      case "неч/чет": // первая группа идет по нечетным
        if (groupType == 1) {
          return (!parity, templateFirst);
        }
        if (groupType == 2) {
          return (parity, templateSecond);
        }
        return (true, !parity ? templateFirst : templateSecond);
      case "чет/неч": // первая группа идет по четным
        if (groupType == 1) {
          return (parity, templateFirst);
        }
        if (groupType == 2) {
          return (!parity, templateSecond);
        }
        return (true, parity ? templateFirst : templateSecond);
      default:
        RegExp filter = RegExp(r'\d\d.\d\d');

        if (filter.hasMatch(type)) { // если в типе перечислены даты, то переходим к их обработке
          String currentDate = DateFormat('dd.MM').format(date);

          String infoSpaceless = type.replaceAll(" ", "");
          List<String> groups = infoSpaceless.split("/");

          if (groupType == 0) { // если подгруппа не выбрана, то проходим по каждой дате
            for (int i = 0; i < groups.length; i++) {
              String group = groups[i];

              for (var j in filter.allMatches(group).map((m)=>m[0])) {
                if (currentDate == j) {
                  return (true, i == 0 ? templateFirst : templateSecond); // тк две группы, то i==0
                }
              }
            }
          } else {
            String group = groups[groupType - 1]; // если подгруппа выбрана, то проходим до/после слеша

            for (var j in filter.allMatches(group).map((m)=>m[0])) {
              if (currentDate == j) {
                return (true, groupType == 1 ? templateFirst : templateSecond);
              }
            }
          }
        } else {
          return (true, type);
        }
    }

    return (false, type);
  }

  List<Widget> buildSchedulePages(Map<String, dynamic> schedule) {
    List<Widget> buffer = [];

    for (int i = 0; i < widget.count; i++) {
      DateTime dayCurrent = widget.from.add(Duration(days: i));
      var scheduleCurrent = schedule[dayCurrent.weekday.toString()];

      if (scheduleCurrent != null) {
        int countOfLessons = 0;

        buffer.add(
            LayoutBuilder(
              builder: (context, c) {
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: scheduleCurrent.length,
                    itemBuilder: (context, j) {
                      var data = scheduleCurrent[j];

                      (bool, String) shouldDiplay = widget.sorting ? isShouldDisplay(
                          data["dayDate"]!.trim(),
                          dayCurrent,
                          widget.groupType,
                      ) : (true, data["dayDate"]!.trim());

                      if (shouldDiplay.$1) {
                        countOfLessons++;

                        String rawTime = data["dayTime"].trim();
                        DateFormat hm = DateFormat("HH:mm");
                        DateTime timeStart = hm.parse(rawTime);
                        DateTime timeEnd = timeStart.add(const Duration(hours: 1, minutes: 30));
                        String rawEnd = hm.format(timeEnd);

                        return Card(
                          child: ListTile(
                            title: Text(
                              data["disciplName"]!.trim(),
                              style: TextStyle(
                                decoration: isPassed(dayCurrent, timeEnd),
                              )
                            ),
                            subtitle: Wrap(
                              spacing: 10,
                              children: [
                                Text("$rawTime - $rawEnd"),
                                Text(data['buildNum'].trim()),
                                Text(data["audNum"].trim()),
                                Text(data["disciplType"].trim()),
                                Text(shouldDiplay.$2),
                                //Text(data["dayDate"].trim()),
                                widget.isStaff
                                    ? Text(data["group"].trim())
                                    : InkWell(
                                  child: Text(data["prepodName"].trim()),
                                  onDoubleTap: () {
                                    Navigator.pushNamed(context, "/StaffInfoPage", arguments: {
                                      "name": data['prepodName'].trim(),
                                      "login": data["prepodLogin"],
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        if (j == scheduleCurrent.length - 1 &&
                            countOfLessons == 0) {
                          return Container(
                              constraints: BoxConstraints(
                                minHeight: c.maxHeight,
                              ),
                              child: buildBeerTime()
                          );
                        }

                        return const SizedBox.shrink();
                      }
                    }
                );
              })
        );
      } else {
        buffer.add(
            buildBeerTime(),
        );
      }
    }

    return buffer;
  }

  TextDecoration isPassed(DateTime dayCurrent, DateTime timeEnd) {
    if (dayCurrent == widget.from) {
      DateTime time = widget.from.copyWith(
          hour: timeEnd.hour,
          minute: timeEnd.minute
      );

      if (time.isBefore(widget.from)) {
        return TextDecoration.lineThrough;
      }
    }

    return TextDecoration.none;
  }

  Widget buildBeerTime() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("There are no lessons on this day"),
        ],
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