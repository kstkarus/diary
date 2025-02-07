import 'package:flutter/material.dart';

import '../../../utils/http_parser.dart';

class CompareWidget extends StatefulWidget {
  const CompareWidget({
    super.key,
  });

  @override
  State<CompareWidget> createState() => _CompareWidgetState();
}

class _CompareWidgetState extends State<CompareWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparison"),
        centerTitle: true,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    if (arguments.isEmpty) {
      return Center(
        child: Text("An error has occurred"),
      );
    }

    final schedule = getSchedule(arguments['groupID']);
    final origSchedule = getSchedule(arguments['originalGroupID']);



    return FutureBuilder(
        future: schedule,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData) {
            return FutureBuilder(
                future: origSchedule,
                builder: (context, origSnapshot) {
                  if (origSnapshot.hasError) {
                    return Center(
                      child: Text(origSnapshot.error.toString()),
                    );
                  }

                  if (origSnapshot.hasData) {
                    var decodedSchedule = snapshot.data?['week_days'] as Map<String, dynamic>;
                    var decodedScheduleKeys = decodedSchedule.keys;
                    var decodedScheduleValues = decodedSchedule.values;

                    var decodedOrigSchedule = origSnapshot.data?['week_days'] as Map<String, dynamic>;
                    var decodedOrigScheduleValues = decodedOrigSchedule.values;

                    return ListView.builder(
                      itemCount: decodedSchedule.keys.length,
                      itemBuilder: (context, i) {
                        var daySchedule = decodedScheduleValues.elementAt(i);
                        var origDaySchedule = decodedOrigScheduleValues.elementAt(i);

                        if (daySchedule.isNotEmpty && origDaySchedule.isNotEmpty) {
                          return Card(
                            child: ListTile(
                              title: Text(decodedScheduleKeys.elementAt(i)),
                              subtitle: Text(daySchedule.toString()),
                            ),
                          );
                        }

                        return SizedBox.shrink();
                      }
                    );
                  }

                  return const LinearProgressIndicator();
                }
            );
          }

          return const LinearProgressIndicator();
        }
    );
  }

  // Center buildHint() {
  //   return const Center(
  //     key: ValueKey(2),
  //     child: Text.rich(TextSpan(children: [
  //       TextSpan(text: "Press "),
  //       WidgetSpan(
  //           child: Icon(
  //             Icons.search_outlined,
  //           )),
  //       TextSpan(text: " to choose group")
  //     ])),
  //   );
  // }
}