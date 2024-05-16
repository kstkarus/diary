import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'schedule_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.schedule});

  final Future<Map<String, dynamic>> schedule;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _weekday = DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildEasyDateTimeLine(),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder(
              future: widget.schedule,
              builder: (context, v) {
                if (v.hasData) {
                    return ScheduleList(schedule: v.data!, index: _weekday); // 1 - пн, 2 - вт, ..., 6 - сб
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

  EasyDateTimeLine buildEasyDateTimeLine() {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        setState(() {
          _weekday = selectedDate.weekday;
        });
      },
      //activeColor: const Color(0xff85A389),
      dayProps: const EasyDayProps(
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        //todayHighlightColor: Color(0xffE1ECC8),
      ),
    );
  }
}
