import 'package:diary/utils/utils.dart';
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
    Map<String, Set<String>> nameOfLessons = {};
    Map<String, Set<String>> typeOfLessons = {};

    var schedule = (widget.schedule['week_days'] as Map<String, dynamic>).values;

    for (int i = 0; i < 7; i++) {
      var scheduleCurrent = schedule.elementAt(i);

      if (scheduleCurrent != null) {
        for (var info in scheduleCurrent) {
          Map<String, dynamic> prepod = info['teacher'] ?? {'name': 'Empty', 'login': ''};
          String prepodName = prepod["name"];

          Map<String, dynamic> discipline = info['discipline'];
          String disciplName = discipline["name"];
          String disciplType = info["original_lesson_type"];

          if (nameOfLessons.containsKey(prepodName)) {
            nameOfLessons[prepodName]!.add(disciplName);
          } else {
            nameOfLessons[prepodName] = <String>{disciplName};
          }

          if (typeOfLessons.containsKey(prepodName)) {
            typeOfLessons[prepodName]!.add(disciplType);
          } else {
            typeOfLessons[prepodName] = <String>{disciplType};
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
          String key = nameOfLessons.keys.elementAt(i);
          String value = nameOfLessons[key].toString();
          Set<String> value2 = typeOfLessons[key]!;

          return Card(
              child: ListTile(
                  trailing: Text(
                    value2.join("\n"),
                    textAlign: TextAlign.center,
                  ),
                  title: Text(key),
                  subtitle: Text(value.substring(1, value.length - 1)),
                  //leading: const Icon(Icons.person)
              )
          );
        },
      ),
    );
  }
}
