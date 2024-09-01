import 'package:diary/pages/auth/welcome_widget.dart';
import 'package:diary/utils/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String helpfulText = "";
  bool isChecking = false;

  int pageIndex = 0;
  PageController controller = PageController(
      initialPage: 0
  );

  void _submitPressed(var readyInstance) {
    if (int.tryParse(_controller.text) == null) {
      setState(() {
        isError = true;
      });

      return;
    }

    setState(() {
      isError = false;
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
      }

      return groups;
    });
  }

  @override
  Widget build(BuildContext context) {
    void changePage() {
      pageIndex = 1;
      controller.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Auth page"),
      // ),
      body: FutureBuilder(
        future: prefs,
        builder: (context, v) {
          if (v.hasData) {
            String cachedGroupID = v.data.getString("GroupID") ?? "";
            String id = v.data.getString("id") ?? "";

            if (cachedGroupID.isNotEmpty && id.isNotEmpty) {
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
              return SafeArea(
                  child: Stack(
                      children: [
                        const BackgroundWidget(),
                        PageView(
                          controller: controller,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            WelcomePage(changePage: changePage),
                            buildAuthForm(v.data, isError, isChecking),
                          ],
                        ),
                      ]
                  )
              );
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

  Widget buildAuthForm(var prefs, bool isError, bool isChecking) {

    return Center(
      child: Stack(
        children: [
          if (isChecking)
            const LinearProgressIndicator(),
          Center(
            child: SizedBox(
              width: 250,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 12,
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Group's number",
                      hintText: "Type here",
                      border: const OutlineInputBorder(),
                      errorText: isError ? "Something went wrong" : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        _submitPressed(prefs);
                      },
                      child: const Text("Submit"),
                  ),
                  const Spacer(
                    flex: 11,
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse("https://github.com/kstkarus/diary"));
                    },
                    child: Text(
                      "github.com/kstkarus/diary",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
