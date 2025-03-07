import 'package:diary/pages/auth/welcome_widget.dart';
import 'package:diary/utils/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  //String? _groupID;
  late List<dynamic> _lastOptions = <dynamic>[];
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future prefs = SharedPreferences.getInstance();

  int pageIndex = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    void changePage() {
      pageIndex = 1;
      controller.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }

    return Scaffold(
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
               const BackgroundWidget().animate().blur(),
                PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    WelcomePage(changePage: changePage),
                    buildAuthForm(v.data),
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

  Widget buildAuthForm(var prefs) {
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: 250,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 12,
              ),
              TypeAheadField<dynamic>(
                controller: _controller,
                suggestionsCallback: (search) async {
                  _searchingWithQuery = search;
      
                  final List<dynamic> options =
                      await getGroups(_searchingWithQuery!);
      
                  if (_searchingWithQuery != search) {
                    return _lastOptions;
                  }
      
                  _lastOptions = options;
      
                  return _lastOptions;
                },
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: "Group's number",
                      hintText: "Type here",
                      border: OutlineInputBorder(),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty || _groupID == null) {
                    //     return "Select a group";
                    //   }
                    //
                    //   return null;
                    // },
                  );
                },
                emptyBuilder: (context) {
                  return const ListTile(
                    title: Text("Error"),
                    subtitle: Text("Unable to get groups from server"),
                  );
                },
                loadingBuilder: (context) {
                  return const LinearProgressIndicator();
                },
                itemBuilder: (context, map) {
                  return ListTile(
                      title: Text(map['group_name']),
                  );
                },
                onSelected: (dynamic value) {
                  _searchingWithQuery = value['group_name'];
                  String groupID = value['kai_id'].toString();

                  prefs.setString("GroupID", groupID);
                  prefs.setString("id", _searchingWithQuery!);

                  Navigator.pushReplacementNamed(context, "/MainPage",
                      arguments: {"groupID": groupID, "id": _searchingWithQuery!});
                },
              ),
              const Spacer(
                flex: 11,
              ),
              InkWell(
                onTap: () {
                  launchUrl(
                    webOnlyWindowName: "_self",
                    Uri.parse("https://github.com/kstkarus/diary")
                  );
                },
                child: Text(
                  "github.com/kstkarus/diary",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
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
    );
  }
}
