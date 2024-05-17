import 'package:flutter/material.dart';
import 'settings_widget.dart';
import 'schedule_widget.dart';
import 'exams_widget.dart';
import 'http_parser.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key, required this.groupID});

  final String groupID;

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _currentPageIndex = 0;
  late Future<Map<String, dynamic>> _schedule;
  
  @override
  void initState() {
    super.initState();
    
    _schedule = getSchedule(widget.groupID);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary"),
      ),
      body: [
        SchedulePage(schedule: _schedule),
        ExamsPage(groupID: widget.groupID),
        SettingsPage(),
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
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
        )
      ],
    );
  }
}
