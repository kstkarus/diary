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
              return Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SettingsButton(
                      title: "Schedule filter",
                      subtitle: "Filtering the schedule based on date, parity, and so on",
                      leading: const Icon(Icons.filter_alt_outlined),
                      trailing: SwitchWidget(sharedPreferences: v.data!)
                  ),
                  SettingsButton(
                      title: "Group type",
                      subtitle: "To view the schedule of a specific group only",
                      leading: const Icon(Icons.filter_alt_outlined),
                      trailing: GroupButton(sharedPreferences: v.data!),
                  ),
                  const Divider(
                  ),
                  SettingsButton(
                    title: "Log out",
                    leading: const Icon(Icons.logout_outlined),
                    func: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("GroupID", "");

                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(context, "/AuthPage", (_) => false);
                      }
                    }
                  ),
                ],
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
    this.subtitle,
    this.leading,
    this.func,
    this.trailing,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Function? func;

  @override
  State<SettingsButton> createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading,
      title: Text(widget.title),
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      trailing: widget.trailing,
      onTap: widget.func != null ? () {
        widget.func!();
      } : null,
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