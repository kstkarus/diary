import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/http_parser.dart';
import 'schedule/schedule_widget.dart';
import '../../utils/http_parser.dart' as http_manager;
import 'exams/exams_widget.dart';
import 'summarize/summarize_widget.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: AppBar(
        leading: const GroupHandler(),
        title: Text('Diary'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/SettingsPage");
            },
            icon: const Icon(Icons.settings),
          ),
          // IconButton(
          //   onPressed: () {
          //     AdaptiveTheme.of(context).toggleThemeMode();
          //   },
          //   icon: getThemeIcon(context),
          // ),
        ],
      ),
      body: FutureBuilder(
          future: http_manager.getSchedule(arguments["groupID"]),
          builder: (context, v) {
            if (v.hasData) {
              return FadeIndexedStack(
                  duration: const Duration(milliseconds: 200),
                  index: _currentPageIndex,
                  children: [
                    SchedulePage(schedule: v.data!),
                    const ExamsPage(),
                    SummarizePage(schedule: v.data!),
                  ]);
            }

            return const LinearProgressIndicator();
          }),
      bottomNavigationBar: buildNavigationBar(),
    );
  }

  NavigationBar buildNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.schedule),
          icon: Icon(Icons.schedule_outlined),
          label: "Schedule",
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.book),
          icon: Icon(Icons.book_outlined),
          label: "Exams",
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.summarize),
          icon: Icon(Icons.summarize_outlined),
          label: "Summarize",
        ),
      ],
    );
  }

  // Future<void> _dialogBuilder(BuildContext context, String defaultValue) {
  //   TextEditingController controller = TextEditingController(
  //     text: defaultValue,
  //   );
  //
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Edit content'),
  //         content: TextField(
  //           controller: controller,
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(),
  //             labelText: "Group",
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Submit'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

class FadeIndexedStack extends StatefulWidget {
  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 800),
  });

  final int index;
  final List<Widget> children;
  final Duration duration;

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}

class GroupHandler extends StatefulWidget {
  const GroupHandler({super.key});

  @override
  State<GroupHandler> createState() => _GroupHandlerState();
}

class _GroupHandlerState extends State<GroupHandler> {
  String? _searchingWithQuery;
  late List<Widget> _lastOptions;

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return IconButton(
          onPressed: () {
            controller.openView();
          },
          icon: Icon(Icons.search),
        );
      },
      suggestionsBuilder: (context, controller) async {
        _searchingWithQuery = controller.text;

        final List<dynamic> options = (await getGroups(_searchingWithQuery!));

        if (_searchingWithQuery != controller.text || options.isEmpty) {
          return _lastOptions;
        }

        _lastOptions = List<ListTile>.generate(options.length, (index) {
          final String item = options[index]['group'];

          return ListTile(
            title: Text(item),
            onTap: () async {
              var prefs = await SharedPreferences.getInstance();
              String groupID = options[index]['id'].toString();

              await prefs.setString("GroupID", groupID);
              await prefs.setString("id", item);

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/MainPage", (_) => false,
                    arguments: {"groupID": groupID, "id": item});
              }
            },
          );
        });

        return _lastOptions;
      },
    );
  }
}
