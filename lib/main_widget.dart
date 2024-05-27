import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'schedule_widget.dart';
import 'exams_widget.dart';
import 'staff_widget.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary"),
        actions: [
          IconButton(
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              icon: getThemeIcon(context),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, "/SettingsPage");
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: [
        const SchedulePage(),
        const ExamsPage(),
        const StaffPage(),
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
