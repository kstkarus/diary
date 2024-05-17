import 'package:flutter/material.dart';
import 'http_parser.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({
    super.key,
    required this.groupID,
  });

  final String groupID;

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  late Future<List<dynamic>> _exams;

  @override
  void initState() {
    super.initState();

    _exams = getExams(widget.groupID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _exams,
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
