import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/http_parser.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final TextEditingController _controller = TextEditingController();
  late String _groupID;
  Future prefs = SharedPreferences.getInstance();

  void _submitPressed() async {
    List<dynamic> groups = await getGroups(_controller.text);
    final readyInstance = await prefs;

    if (int.tryParse(_controller.text) != null && groups.isNotEmpty && groups[0]["group"] == _controller.text) {
      setState(() {
        _groupID = groups[0]["id"].toString();
        readyInstance.setString("GroupID", _groupID);

        Navigator.pushReplacementNamed(context, "/MainPage", arguments: {
          "groupID": _groupID,
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid group's number. Try again"),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auth page"),
      ),
      body: FutureBuilder(
        future: prefs,
        builder: (context, v) {
          if (v.hasData) {
            String cachedGroupID = v.data.getString("GroupID") ?? "";

            if (cachedGroupID != "") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/MainPage",
                    arguments: {
                      'groupID': cachedGroupID,
                    },
                    (_) => false,
                );
              });
            } else {
              return buildAuthForm();
            }
          }

          if (v.hasError) {
            return Text("An error occurred: ${v.error}");
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Center buildAuthForm() {
    return Center(
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "diary",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Group's number",
                hintText: "Type here",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  _submitPressed();
                },
                child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
