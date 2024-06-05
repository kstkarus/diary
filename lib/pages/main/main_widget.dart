import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
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

  Icon getThemeIcon(BuildContext context) {
    switch (AdaptiveTheme.of(context).mode) {
      case AdaptiveThemeMode.light: {
        return const Icon(Icons.light_mode_outlined);
      }
      case AdaptiveThemeMode.dark: {
        return const Icon(Icons.dark_mode_outlined);
      }
      case AdaptiveThemeMode.system: {
        return const Icon(Icons.brightness_auto_outlined);
      }
      default: {
        return const Icon(Icons.error_outline);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text("Diary ${arguments['id']}"),
        actions: [
          IconButton(
            // onPressed: () => _dialogBuilder(
            //   context,
            //   arguments['groupID'],
            // ),
            onPressed: (){
              Navigator.pushNamed(context, "/SettingsPage");
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              icon: getThemeIcon(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: http_manager.getSchedule(arguments["groupID"]),
        builder: (context, v) {
          if (v.hasData) {
            return IndexedStack(
              index: _currentPageIndex,
              children: [
                SchedulePage(
                    schedule: v.data!
                ),
                const ExamsPage(),
                SummarizePage(
                  schedule: v.data!
                ),
              ],
            );
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

  Future<void> _dialogBuilder(BuildContext context, String defaultValue) {
    TextEditingController controller = TextEditingController(
      text: defaultValue,
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit content'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Group",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}