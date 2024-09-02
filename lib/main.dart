import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'pages/auth/auth_widget.dart';
import 'pages/main/main_widget.dart';
import 'pages/main/settings/settings_widget.dart';
import 'pages/main/staff/staff_info_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  static final _defaultLightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  static final _defaultDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      light: ThemeData(
        colorScheme: _defaultLightColorScheme,
        useMaterial3: true,
        fontFamily: 'NeueMachina'
      ),
      dark: ThemeData(
        colorScheme: _defaultDarkColorScheme,
        useMaterial3: true,
        fontFamily: 'NeueMachina'
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
  }
}