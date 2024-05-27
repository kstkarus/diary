import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'auth_widget.dart';
import 'main_widget.dart';
import 'settings_widget.dart';
import 'staff_info_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  static final _defaultDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (light, dark) {
      return AdaptiveTheme(
        initial: AdaptiveThemeMode.system,
        light: ThemeData(
          colorScheme: light ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        dark: ThemeData(
          colorScheme: dark ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        builder: (theme, darkTheme) => MaterialApp(
          title: 'Diary',
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: "/AuthPage",
          routes: {
            "/AuthPage": (context) => const AuthWidget(),
            "/MainPage": (context) => const MainWidget(),
            "/SettingsPage": (context) => const SettingsPage(),
            "/StaffInfoPage": (context) => const StaffInfoPage(),
          },
        ),
      );
    });
  }
}