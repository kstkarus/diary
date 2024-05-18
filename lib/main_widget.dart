import 'package:flutter/material.dart';
import 'settings_widget.dart';
import 'schedule_widget.dart';
import 'exams_widget.dart';
import 'staff_widget.dart';
import 'http_parser.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _currentPageIndex = 0;
  late Future<Map<String, dynamic>> _schedule;
  
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    _schedule = getSchedule(
      arguments["groupID"],
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Diary"),
            IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const SettingsPage();
                        })
                  );
                },
                icon: const Icon(Icons.settings_outlined),
            )
          ],
        ),
      ),
      body: [
        SchedulePage(schedule: _schedule),
        ExamsPage(groupID: arguments["groupID"]),
        StaffPage(),
      ][_currentPageIndex],
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
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
          label: "Staff",
        ),
      ],
    );
  }
}
