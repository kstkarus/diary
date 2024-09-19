import 'package:diary/pages/auth/welcome_widget.dart';
import 'package:diary/utils/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/http_parser.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  String? _searchingWithQuery;
  late List<String> _lastOptions = <String>[];

  Future prefs = SharedPreferences.getInstance();
  bool isError = false;
  String helpfulText = "";
  bool isChecking = false;

  int pageIndex = 0;
  PageController controller = PageController(initialPage: 0);

  void _submitPressed(var readyInstance) {
    if (int.tryParse(_searchingWithQuery!) == null) {
      setState(() {
        isError = true;
      });

      return;
    }

    setState(() {
      isError = false;
      isChecking = true;
    });

    getGroups(_searchingWithQuery!).then((groups) {
      if (groups.isNotEmpty && groups[0]["group"] == _searchingWithQuery!) {
        setState(() {
          String groupID = groups[0]["id"].toString();
          readyInstance.setString("GroupID", groupID);
          readyInstance.setString("id", _searchingWithQuery!);
          isChecking = false;

          Navigator.pushReplacementNamed(context, "/MainPage",
              arguments: {"groupID": groupID, "id": _searchingWithQuery!});
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
      controller.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
                  child: Stack(children: [
                const BackgroundWidget(),
                PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    WelcomePage(changePage: changePage),
                    buildAuthForm(v.data, isError, isChecking),
                  ],
                ),
              ]));
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
          if (isChecking) const LinearProgressIndicator(),
          Center(
            child: SizedBox(
              width: 250,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 12,
                  ),
                  TypeAheadField(
                    suggestionsCallback: (search) async {
                      _searchingWithQuery = search;

                      final Iterable<dynamic> options =
                          await getGroups(_searchingWithQuery!);

                      if (_searchingWithQuery != search) {
                        return _lastOptions;
                      }

                      _lastOptions =
                          options.map((v) => v["group"].toString()).toList();

                      return _lastOptions;
                    },
                    builder: (context, controller, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: "Group's number",
                          hintText: "Type here",
                          border: const OutlineInputBorder(),
                          errorText: isError ? "Something went wrong" : null,
                        ),
                      );
                    },
                    itemBuilder: (context, string) {
                      return ListTile(title: Text(string));
                    },
                    onSelected: (String value) {

                    },
                  ),
                  // TextField(
                  //   controller: _controller,
                  //   decoration: InputDecoration(
                  //     labelText: "Group's number",
                  //     hintText: "Type here",
                  //     border: const OutlineInputBorder(),
                  //     errorText: isError ? "Something went wrong" : null,
                  //   ),
                  // ),
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
