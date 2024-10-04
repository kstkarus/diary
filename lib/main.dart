import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/auth/auth_widget.dart';
import 'pages/main/main_widget.dart';
import 'pages/main/settings/settings_widget.dart';
import 'pages/main/staff/staff_info_widget.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  final prefs = await SharedPreferences.getInstance();
  final colorScheme = prefs.getString("themeColor") ?? "0000FFFF";

  runApp(
      MyApp(
        savedThemeMode: savedThemeMode,
        colorScheme: colorScheme.hexToColor(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode, required this.colorScheme});

  final AdaptiveThemeMode? savedThemeMode;
  final Color colorScheme;

  // static final _defaultLightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
  // static final _defaultDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      light: ThemeData(
        colorSchemeSeed: colorScheme,
        useMaterial3: true,
        fontFamily: 'NeueMachina'
      ),
      dark: ThemeData(
        colorSchemeSeed: colorScheme,
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'NeueMachina'
      ),
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
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