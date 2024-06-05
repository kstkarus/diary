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
  Future prefs = SharedPreferences.getInstance();
  bool isError = false;
  bool isChecking = false;

  void _submitPressed(var readyInstance) {
    if (int.tryParse(_controller.text) == null) {
      setState(() {
        isError = true;
      });

      return;
    }

    setState(() {
      isChecking = true;
    });

    getGroups(_controller.text).then((groups) {
      if (groups.isNotEmpty && groups[0]["group"] == _controller.text) {
        setState(() {
          String groupID = groups[0]["id"].toString();
          readyInstance.setString("GroupID", groupID);
          readyInstance.setString("id", _controller.text);
          isChecking = false;

          Navigator.pushReplacementNamed(context, "/MainPage", arguments: {
            "groupID": groupID,
            "id": _controller.text
          });
        });
      } else {
        setState(() {
          isChecking = false;
          isError = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid group's number. Try again"),
            )
        );
      }

      return groups;
    });
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
            String id = v.data.getString("id") ?? "";

            if (cachedGroupID != "") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/MainPage",
                    arguments: {
                      'groupID': cachedGroupID,
                      'id': id,
                    },
                    (_) => false,
                );
              });
            } else {
              return buildAuthForm(v.data, isError, isChecking);
            }
          }

          if (v.hasError) {
            return Text("An error occurred: ${v.error}");
          }

          return const Center(child: LinearProgressIndicator());
        },
      ),
    );
  }

  Center buildAuthForm(var prefs, bool isError, bool isChecking) {
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
              decoration: InputDecoration(
                labelText: "Group's number",
                hintText: "Type here",
                border: const OutlineInputBorder(),
                errorText: isError ? "Something went wrong" : null,
                prefix: isChecking
                    ? const Center(child: LinearProgressIndicator())
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  _submitPressed(prefs);
                },
                child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
