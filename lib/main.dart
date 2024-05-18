import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'auth_widget.dart';
import 'main_widget.dart';
import 'settings_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);
  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (light, dark) {
      return MaterialApp(
        title: 'Diary',
        theme: ThemeData(
          colorScheme: light ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: dark ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.light,
        initialRoute: "/AuthPage",
        routes: {
          "/AuthPage": (context) => const AuthWidget(),
          "/MainPage": (context) => const MainWidget(),
          "/SettingsPage": (context) => const SettingsPage(),
        },
      );
    });
  }
}