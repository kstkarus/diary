import 'package:flutter/material.dart';
import 'http_parser.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    Future<List<dynamic>> exams = getExams(
      arguments["groupID"]
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: exams,
          builder: (context, v) {
            if (v.hasData) {
              return ListView.builder(
                itemCount: v.data!.length,
                itemBuilder: (context, i) {
                  return buildExamTile(v.data![i]);
                },
              );
            } else if (v.hasError) {
              Text("An error occurred ${v.error}");
            }

            return const Center(child: CircularProgressIndicator());
          }
      ),
    );
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
}
