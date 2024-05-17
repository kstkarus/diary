import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'schedule_list.dart';
import 'package:week_number/iso.dart';

bool getWeekParity(DateTime date) {
  return date.weekNumber % 2 == 0;
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.schedule});

  final Future<Map<String, dynamic>> schedule;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _weekday = DateTime.now().weekday;
  bool _weekParity = getWeekParity(DateTime.now());
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        buildEasyDateTimeLine(context),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder(
              future: widget.schedule,
              builder: (context, v) {
                if (v.hasData) {
                    return ScheduleList(
                      schedule: v.data!,
                      index: _weekday,
                      parity: _weekParity,
                      date: _selectedDate,
                    ); // 1 - пн, 2 - вт, ..., 6 - сб
                } else if (v.hasError) {
                  return Text("${v.error}");
                }
                return const Center(child: CircularProgressIndicator());
              },
          ),
        ),
      ],
    );
  }

  EasyDateTimeLine buildEasyDateTimeLine(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        setState(() {
          _weekday = selectedDate.weekday;
          _weekParity = getWeekParity(selectedDate);
          _selectedDate = selectedDate;
        });
      },
      //activeColor: Theme.of(context).,
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
