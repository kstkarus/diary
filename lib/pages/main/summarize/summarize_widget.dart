import 'package:flutter/material.dart';

const List<String> weekdayName = [
  "Понедельник",
  "Вторник",
  "Среда",
  "Четверг",
  "Пятница",
  "Суббота",
  "Воскресенье"
];

class SummarizePage extends StatefulWidget {
  const SummarizePage({
    super.key,
    required this.schedule,
  });

  final Map<String, dynamic> schedule;

  @override
  State<SummarizePage> createState() => _SummarizePageState();
}

class _SummarizePageState extends State<SummarizePage> {
  @override
  Widget build(BuildContext context) {
    Map<String, Set<int>> nameOfLessons = {};

    for (int i = 1; i < 7; i++) {
      var scheduleCurrent = widget.schedule[i.toString()];

      if (scheduleCurrent != null) {
        for (var info in scheduleCurrent) {
          if (nameOfLessons.containsKey(info["disciplName"])) {
            nameOfLessons[info["disciplName"]]!.add(i);
          } else {
            nameOfLessons[info["disciplName"]] = <int>{i};
          }
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
          itemCount: nameOfLessons.length, // кол-во дней в неделю
          shrinkWrap: true,
          itemBuilder: (c, i) {
            return Card(
                child: ListTile(
                  title: Text(nameOfLessons.keys.elementAt(i)),
                  subtitle: buildWeekNames(nameOfLessons.values.elementAt(i)),
                  trailing: const Text(
                    "---",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                )
            );
          },
      ),
    );
  }

  Widget buildWeekNames(Set<int> nameOfLessons) {
    List<Widget> buffer = [];

    for (var v in nameOfLessons) {
      buffer.add(
        Text(weekdayName[v - 1])
      );
    }

    return Wrap(
      spacing: 10,
      children: buffer,
    );
  }
}
