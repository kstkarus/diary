import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SettingsButton(title: "Group type", trailing: GroupButton()),
              SettingsButton(title: "Log out", func: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("GroupID", "");

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, "/AuthPage", (_) => false);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatefulWidget {
  const SettingsButton({
    super.key,
    required this.title,
    this.func,
    this.trailing,
  });

  final String title;
  final Widget? trailing;
  final Function? func;

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: widget.func != null ? () {
          widget.func!();
        } : null,
        child: ListTile(
          title: Text(widget.title),
          trailing: widget.trailing,
        ),
      ),
    );
  }
}

const List<String> list = <String>['None', 'First', 'Second'];

class GroupButton extends StatefulWidget {
  const GroupButton({super.key});

  @override
  State<GroupButton> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  late final Future<SharedPreferences> prefs;
  String selected = list.first;

  @override
  void initState() {
    super.initState();

    prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefs,
      builder: (context, v) {
        if (v.hasData) {
          return DropdownMenu(
              initialSelection: list.elementAt(v.data!.getInt("groupType") ?? list.indexOf(selected)),
              dropdownMenuEntries: list.map<DropdownMenuEntry>((String value) {
                return DropdownMenuEntry(
                    value: value,
                    label: value,
                );
              }).toList(),
              inputDecorationTheme: const InputDecorationTheme(
                outlineBorder: BorderSide.none,
                border: InputBorder.none
              ),
              onSelected: (value) {
                setState(() {
                  selected = value;
                });

                v.data!.setInt("groupType", list.indexOf(value));
              }
          );
        }

        return const CircularProgressIndicator();
      }
    );
  }
}