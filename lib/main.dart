import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_widget.dart';
import 'main_widget.dart';
import 'http_parser.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColor = ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen);
  static final _defaultDarkColor = ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen, brightness: Brightness.dark);
  
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColor, darkColor) {
        return MaterialApp(
          title: 'Diary',
          theme: ThemeData(
            colorScheme: lightColor ?? _defaultLightColor,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColor ?? _defaultDarkColor,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.light,
          home: const MyHomePage(title: 'Diary'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isNumberProvided = false;
  final TextEditingController _controller = TextEditingController();
  late String _groupID;

  void _submitPressed() async {
    List<dynamic> groups = await getGroups(_controller.text);
    final prefs = await SharedPreferences.getInstance();

    if (int.tryParse(_controller.text) != null && groups.isNotEmpty && groups[0]["group"] == _controller.text) {
      setState(() {
        _isNumberProvided = true;
        _groupID = groups[0]["id"].toString();
        prefs.setInt("groupID", groups[0]["id"]);
        prefs.setInt("groupNumber", int.parse(_controller.text));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid group's number. Try again"),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //return !_isNumberProvided ? buildAuthPage(context) : MainWidget(groupID: _groupID,);
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, v) {
          if (v.hasData) {
            int? id = v.data!.getInt("groupID") ?? 0;

            return id == 0 ? buildAuthPage(context) : MainWidget(groupID: id.toString());
          } else if (v.hasError) {
            return Text("An error occurred: ${v.error}");
          }

          return const CircularProgressIndicator();
        },
    );
  }

  Scaffold buildAuthPage(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    body: AuthWidget(
      textController: _controller,
      submitFunction: _submitPressed,
    ),
  );
  }
}
