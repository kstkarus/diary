import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:diary/pages/main/staff/staff_widget.dart';
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
                    SettingsButton(
                      title: "App theme",
                      subtitle: const Text("Just tap here to change theme of app"),
                      leading: const ThemeDisplay(),
                      func: () {
                        AdaptiveTheme.of(context).toggleThemeMode();
                      },
                    ),
                    SettingsButton(
                      title: "Color accent",
                      subtitle: const Text(
                          "Change the colors to suit your preferences"),
                      leading: const Icon(Icons.colorize_outlined),
                      trailing: ColorAccentWidget(sharedPreferences: v.data!),
                    ),
                    const Divider(),
                    SettingsButton(
                        title: "Schedule filter",
                        subtitle: const Text(
                            "Filtering the schedule based on date, parity, and so on"),
                        leading: const Icon(Icons.filter_alt_outlined),
                        trailing: SwitchWidget(
                          sharedPreferences: v.data!,
                          dataKey: "groupSorting",
                          defaultValue: true,
                        )),
                    SettingsButton(
                      title: "Group type",
                      subtitle: const Text(
                          "To view the schedule of a specific group only"),
                      leading: const Icon(Icons.filter_alt_outlined),
                      trailing: GroupButton(sharedPreferences: v.data!),
                    ),
                    const Divider(),
                    SettingsButton(
                      title: "Display in local Time",
                      subtitle: const Text(
                          "Shows the schedule in your local time for clarity"),
                      leading: const Icon(Icons.more_time_outlined),
                      trailing: SwitchWidget(
                        sharedPreferences: v.data!,
                        dataKey: "groupTimeZone",
                        defaultValue: true,
                      ),
                    ),
                    const Divider(),
                    SettingsButton(
                      title: "Teacher's schedule",
                      subtitle: const Text("View the schedule of any teacher"),
                      func: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) {
                                return const StaffPage();
                              },
                              settings: RouteSettings(arguments: {
                                'sorting': v.data!.getBool('groupSorting'),
                                'matchTimeZone':
                                    v.data!.getBool('groupTimeZone')
                              })),
                        );
                      },
                      leading: const Icon(Icons.groups_outlined),
                    ),
                    //const Divider(),
                    // SettingsButton(
                    //   title: "Log out",
                    //   leading: const Icon(Icons.logout_outlined),
                    //   func: () async {
                    //     showDialog(
                    //         context: context,
                    //         barrierDismissible: false,
                    //         builder: (context) {
                    //           return AlertDialog(
                    //             title: const Text("Log out?"),
                    //             content: const Text(
                    //                 "The saved schedule will be deleted"),
                    //             actions: [
                    //               TextButton(
                    //                 onPressed: () {
                    //                   Navigator.pop(context);
                    //                 },
                    //                 child: const Text("No"),
                    //               ),
                    //               TextButton(
                    //                 onPressed: () async {
                    //                   if (context.mounted) {
                    //                     await v.data!.remove("GroupID");
                    //
                    //                     Navigator.pushNamedAndRemoveUntil(
                    //                         context, "/AuthPage", (_) => false);
                    //                   }
                    //                 },
                    //                 child: const Text("Yes"),
                    //               ),
                    //             ],
                    //           );
                    //         });
                    //   },
                    // ),
                  ],
                );
              }

              return const LinearProgressIndicator();
            }),
      ),
    );
  }

  // void compareScreen(BuildContext context) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return const CompareWidget();
  //   }));
  // }
}

// class CompareWidget extends StatefulWidget {
//   const CompareWidget({
//     super.key,
//   });
//
//   @override
//   State<CompareWidget> createState() => _CompareWidgetState();
// }
//
// class _CompareWidgetState extends State<CompareWidget> {
//   String? _searchingWithQuery;
//   String? selectedGroup;
//   late Iterable<Widget> _lastOptions = <Widget>[];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Comparison"),
//         actions: [buildSearch()],
//       ),
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 200),
//         child: selectedGroup != null ? buildBody() : buildHint(),
//       ),
//     );
//   }
//
//   SearchAnchor buildSearch() {
//     return SearchAnchor(builder: (context, controller) {
//       return IconButton(
//           onPressed: () {
//             controller.openView();
//           },
//           icon: const Icon(Icons.search_outlined));
//     }, suggestionsBuilder: (context, controller) async {
//       _searchingWithQuery = controller.text;
//
//       final List<dynamic> options = (await getGroups(_searchingWithQuery!));
//
//       if (_searchingWithQuery != controller.text || options.isEmpty) {
//         return _lastOptions;
//       }
//
//       _lastOptions = List<ListTile>.generate(options.length, (index) {
//         final String item = options[index]['group'];
//
//         return ListTile(
//           title: Text(item),
//           onTap: () {
//             setState(() {
//               selectedGroup = item;
//             });
//             controller.closeView(item);
//           },
//         );
//       });
//
//       return _lastOptions;
//     });
//   }
//
//   Widget buildBody() {
//     return Center(
//       key: const ValueKey(1),
//       child: CircularProgressIndicator(),
//     );
//   }
//
//   Center buildHint() {
//     return const Center(
//       key: ValueKey(2),
//       child: Text.rich(TextSpan(children: [
//         TextSpan(text: "Press "),
//         WidgetSpan(
//             child: Icon(
//           Icons.search_outlined,
//         )),
//         TextSpan(text: " to choose group")
//       ])),
//     );
//   }
// }

class ColorAccentWidget extends StatefulWidget {
  const ColorAccentWidget({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  State<ColorAccentWidget> createState() => _ColorAccentWidgetState();
}

class _ColorAccentWidgetState extends State<ColorAccentWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
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

                          setState(() {
                            widget.sharedPreferences.setString(
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
    required this.dataKey,
    this.defaultValue = false,
  });

  final SharedPreferences sharedPreferences;
  final String dataKey;
  final bool defaultValue;

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool value;

  @override
  Widget build(BuildContext context) {
    value = widget.defaultValue;

    return Switch(
      value: widget.sharedPreferences.getBool(widget.dataKey) ?? value,
      onChanged: (bool newValue) {
        setState(() {
          value = newValue;
        });

        widget.sharedPreferences.setBool(widget.dataKey, newValue);
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

class ThemeDisplay extends StatefulWidget {
  const ThemeDisplay({super.key});

  @override
  State<ThemeDisplay> createState() => _ThemeDisplayState();
}

class _ThemeDisplayState extends State<ThemeDisplay> {
  @override
  Widget build(BuildContext context) {
    switch (AdaptiveTheme.of(context).mode) {
      case AdaptiveThemeMode.light:
        {
          return const Icon(Icons.light_mode_outlined);
        }
      case AdaptiveThemeMode.dark:
        {
          return const Icon(Icons.dark_mode_outlined);
        }
      case AdaptiveThemeMode.system:
        {
          return const Icon(Icons.brightness_auto_outlined);
        }
      default:
        {
          return const Icon(Icons.error_outline);
        }
    }
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
