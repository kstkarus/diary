import 'package:flutter/material.dart';
import '../../../utils/http_parser.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({
    super.key,
    required this.schedule
  });

  final Map<String, dynamic> schedule;

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    //final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    // Future<List<dynamic>> exams = getExams(
    //   arguments["groupID"]
    // );

    return const Center(
      child: Text(
          "You don't have any exams yet"
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: FutureBuilder(
    //       future: exams,
    //       builder: (context, v) {
    //         if (v.hasData) {
    //           if (v.data!.isEmpty) {
    //            return const Center(
    //              child: Text(
    //                "You don't have any exams yet"
    //              ),
    //            );
    //           }
    //
    //           return ListView.builder(
    //             itemCount: v.data!.length,
    //             itemBuilder: (context, i) {
    //               return buildExamTile(v.data![i]);
    //             },
    //           );
    //         } else if (v.hasError) {
    //           Text("An error occurred ${v.error}");
    //         }
    //
    //         return const LinearProgressIndicator();
    //       }
    //   ),
    // );
  }

  Card buildExamTile(Map<String, dynamic> data) {
    return Card(
      child: ListTile(
        title: Text(data['disciplName'].trim()),
        subtitle: Wrap(
          spacing: 10,
          children: [
            Text(data['examDate'].trim()),
            Text(data['examTime'].trim()),
            Text(data['buildNum'].trim()),
            Text(data['audNum'].trim()),
            Text(data['prepodName'].trim()),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
