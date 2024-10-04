import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:diary/utils/http_parser.dart';
import 'package:diary/utils/utils.dart';
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
                    const SettingsButton(
                      title: "Color accent",
                      subtitle:
                          Text("Change the colors to suit your preferences"),
                      leading: Icon(Icons.color_lens_outlined),
                      trailing: ColorAccentWidget(),
                    ),
                    const Divider(),
                    SettingsButton(
                        title: "Schedule filter",
                        subtitle: const Text(
                            "Filtering the schedule based on date, parity, and so on"),
                        leading: const Icon(Icons.filter_alt_outlined),
                        trailing: SwitchWidget(sharedPreferences: v.data!)),
                    SettingsButton(
                      title: "Group type",
                      subtitle: const Text(
                          "To view the schedule of a specific group only"),
                      leading: const Icon(Icons.filter_alt_outlined),
                      trailing: GroupButton(sharedPreferences: v.data!),
                    ),
                    const Divider(),
                    SettingsButton(
                      title: "Compare schedule",
                      subtitle:
                          const Text("Compare the schedule with other groups"),
                      func: () {
                        compareScreen(context);
                      },
                      leading: const Icon(Icons.groups_outlined),
                    ),
                    const Divider(),
                    SettingsButton(
                      title: "Log out",
                      leading: const Icon(Icons.logout_outlined),
                      func: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Log out?"),
                                content: const Text(
                                    "All saved data will be deleted, including preferences"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      v.data!.clear();
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("GroupID", "");

                                      if (context.mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, "/AuthPage", (_) => false);
                                      }
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                );
              }

              return const LinearProgressIndicator();
            }),
      ),
    );
  }

  void compareScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const CompareWidget();
    }));
  }
}

class CompareWidget extends StatefulWidget {
  const CompareWidget({
    super.key,
  });

  @override
  State<CompareWidget> createState() => _CompareWidgetState();
}

class _CompareWidgetState extends State<CompareWidget> {
  String? _searchingWithQuery;
  String? selectedGroup;
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparison"),
        actions: [buildSearch()],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: selectedGroup != null ? buildBody() : buildHint(),
      ),
    );
  }

  SearchAnchor buildSearch() {
    return SearchAnchor(builder: (context, controller) {
      return IconButton(
          onPressed: () {
            controller.openView();
          },
          icon: const Icon(Icons.search_outlined));
    }, suggestionsBuilder: (context, controller) async {
      _searchingWithQuery = controller.text;

      final List<dynamic> options = (await getGroups(_searchingWithQuery!));

      if (_searchingWithQuery != controller.text || options.isEmpty) {
        return _lastOptions;
      }

      _lastOptions = List<ListTile>.generate(options.length, (index) {
        final String item = options[index]['group'];

        return ListTile(
          title: Text(item),
          onTap: () {
            setState(() {
              selectedGroup = item;
            });
            controller.closeView(item);
          },
        );
      });

      return _lastOptions;
    });
  }

  Widget buildBody() {
    return Center(
      key: const ValueKey(1),
      child: CircularProgressIndicator(),
    );
  }

  Center buildHint() {
    return const Center(
      key: ValueKey(2),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: "Press "),
        WidgetSpan(
            child: Icon(
          Icons.search_outlined,
        )),
        TextSpan(text: " to choose group")
      ])),
    );
  }
}

class ColorAccentWidget extends StatefulWidget {
  const ColorAccentWidget({
    super.key,
  });

  @override
  State<ColorAccentWidget> createState() => _ColorAccentWidgetState();
}

class _ColorAccentWidgetState extends State<ColorAccentWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   behavior: SnackBarBehavior.floating,
        //   content: Text("Will be implemented in future updates."),
        // ));

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("Color accent"),
                content: Wrap(
                  //spacing: 0,
                  runSpacing: 10,
                  children: [
                    for (var v in Colors.primaries)
                      ElevatedButton(
                        onPressed: () async {
                          AdaptiveTheme.of(context).setTheme(
                            light: ThemeData(
                                useMaterial3: true,
                                brightness: Brightness.light,
                                colorSchemeSeed: v,
                                fontFamily: 'NeueMachina'),
                            dark: ThemeData(
                                useMaterial3: true,
                                brightness: Brightness.dark,
                                colorSchemeSeed: v,
                                fontFamily: 'NeueMachina'),
                          );

                          final prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            prefs.setString(
                                "themeColor", v.toHex(withAlpha: true));
                          });
                        },
                        child: null,
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: v,
                            minimumSize: const Size(40, 40)),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Okay"),
                  ),
                ],
              );
            });
      },
      child: null,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({
    super.key,
    required this.sharedPreferences,
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
  final Widget? subtitle;
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
      subtitle: widget.subtitle,
      trailing: widget.trailing,
      onTap: widget.func != null
          ? () {
              widget.func!();
            }
          : null,
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
        initialSelection:
            list.elementAt(v.getInt("groupType") ?? list.indexOf(selected)),
        dropdownMenuEntries: list.map<DropdownMenuEntry>((String value) {
          return DropdownMenuEntry(
            value: value,
            label: value,
          );
        }).toList(),
        inputDecorationTheme: const InputDecorationTheme(
            outlineBorder: BorderSide.none, border: InputBorder.none),
        onSelected: (value) {
          setState(() {
            selected = value;
          });

          v.setInt("groupType", list.indexOf(value));
        });
  }
}
