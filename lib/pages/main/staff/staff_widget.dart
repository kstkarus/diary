import 'package:flutter/material.dart';
import '../../../utils/http_parser.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  String? _searchingWithQuery;
  final TextEditingController _controller = TextEditingController();
  Future<List<dynamic>> staffNames = getStaff('');

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher's schedule"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Staff's name",
                hintText: "Type here",
                helperText: "Type at least 3 symbols",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              onChanged: (String text) {
                setState(() {
                  _searchingWithQuery = text;

                  final options = getStaff(_searchingWithQuery!);

                  if (_searchingWithQuery == text) {
                    staffNames = options;
                  }
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                  future: staffNames,
                  builder: (context, v) {
                    if (v.hasData) {
                      if (v.data!.isEmpty) {
                        return const Center(child: Text("There's nothing here..."));
                      }

                      return ListView.builder(
                        itemCount: v.data!.length,
                        itemBuilder: (context, i) {
                          return buildStaffTile(v.data![i], arguments);
                        }
                      );
                    }

                    if (v.hasError) {
                      return Text("An error occurred: ${v.error}");
                    }

                    return const Center(child: CircularProgressIndicator());
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildStaffTile(Map<String, dynamic> data, Map<dynamic, dynamic> arguments) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/StaffInfoPage",
            arguments: {
              "name": data['lecturer'],
              "login": data['id'],
              "sorting": arguments['sorting'],
              "matchTimeZone": arguments['matchTimeZone'],
            }
          );
        },
        child: ListTile(
          title: Text(data['lecturer'].trim()),
        ),
      ),
    );
  }
}
