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
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, v) {
            if (v.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SettingsButton(title: "Group type", trailing: GroupButton(sharedPreferences: v.data!)),
                    SettingsButton(title: "Schedule filter", trailing: SwitchWidget(sharedPreferences: v.data!)),
                    const Divider(
                      indent: 8,
                      endIndent: 8,
                    ),
                    SettingsButton(title: "Log out", func: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("GroupID", "");

                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, "/AuthPage", (_) => false);
                      }
                    }),
                  ],
                ),
              );
            }

            return const LinearProgressIndicator();
          }
        ),
      ),
    );
  }
}

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({
    super.key, required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.sharedPreferences.getBool("groupSorting") ?? value,
      onChanged: (bool newValue) async {
        setState(() {
          value = newValue;
        });

        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("groupSorting", newValue);
      },
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
  const GroupButton({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<GroupButton> createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  String selected = list.first;

  @override
  Widget build(BuildContext context) {
    SharedPreferences v = widget.sharedPreferences;

    return DropdownMenu(
        initialSelection: list.elementAt(v.getInt("groupType") ?? list.indexOf(selected)),
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

          v.setInt("groupType", list.indexOf(value));
        }
    );
  }
}