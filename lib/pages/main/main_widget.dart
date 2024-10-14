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

  void onDestChange(int idx) {
    setState(() {
      _currentPageIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final useSideNavRail = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      appBar: AppBar(
        leading: useSideNavRail ? null : const GroupHandler(),
        title: Text('Diary'),
        centerTitle: !useSideNavRail,
        actions: useSideNavRail
            ? null : [
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
      body: Row(
        children: [
          if (useSideNavRail)
            SideNavRail(
              selectedIndex: _currentPageIndex,
              onDestSelected: onDestChange,
              leading: const GroupHandler(),
              trailing: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/SettingsPage");
                },
                icon: const Icon(Icons.settings),
              ),
            ),
          Expanded(
            child: FutureBuilder(
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
          ),
        ],
      ),
      bottomNavigationBar: useSideNavRail
          ? null
          : BottomNavBar(
              selectedIndex: _currentPageIndex, onDestSelected: onDestChange),
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

class Destination {
  const Destination(this.icon, this.label, this.selectedIcon);
  final Icon icon;
  final String label;
  final Icon selectedIcon;
}

const List<Destination> destinations = [
  Destination(Icon(Icons.schedule_outlined), 'Schedule', Icon(Icons.schedule)),
  Destination(Icon(Icons.book_outlined), 'Exams', Icon(Icons.book)),
  Destination(Icon(Icons.summarize_outlined), 'Summarize', Icon(Icons.summarize)),
];

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {super.key, required this.selectedIndex, this.onDestSelected});

  final int selectedIndex;
  final ValueChanged<int>? onDestSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestSelected,
      destinations: destinations.map((dest) {
        return NavigationDestination(icon: dest.icon, label: dest.label, selectedIcon: dest.selectedIcon);
      }).toList(),
    );
  }
}

class SideNavRail extends StatelessWidget {
  const SideNavRail(
      {super.key,
      required this.selectedIndex,
      this.onDestSelected,
      this.leading,
      this.trailing});

  final int selectedIndex;
  final ValueChanged<int>? onDestSelected;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestSelected,
      labelType: NavigationRailLabelType.all,
      leading: leading,
      trailing: trailing,
      destinations: destinations.map((dest) {
        return NavigationRailDestination(
            icon: dest.icon, label: Text(dest.label), selectedIcon: dest.selectedIcon);
      }).toList(),
    );
  }
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
          icon: Icon(Icons.edit),
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
