import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth_widget.dart';
import 'main_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Diary'),
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
  late TextEditingController _controller;

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    if (!_isNumberProvided) {
      _controller = TextEditingController();
    }
  }

  void _submitPressed() {
    // проверка на номер группы
    // если корректна, то запись в бд
    if (int.tryParse(_controller.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid group's number. Try again"),
        )
      );
      return;
    }

    setState(() {
      _isNumberProvided = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isNumberProvided ? MainWidget() : AuthWidget(
        textController: _controller,
        submitFunction: _submitPressed,
      ),
      bottomNavigationBar: !_isNumberProvided ?  null : buildNavigationBar(),
    );
  }

  NavigationBar buildNavigationBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.grade),
          icon: Icon(Icons.grade_outlined),
          label: "Scores",
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
