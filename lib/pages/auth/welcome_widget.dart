import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.changePage
  });

  final Function changePage;

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
          builder: (context, box) {
            return Column(
              children: [
                const Spacer(
                  flex: 4,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: box.maxWidth/10,
                    ),
                    const Text(
                      "Diary",
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Row( // TODO: переделать отступ
                  children: [
                    SizedBox(
                      width: box.maxWidth/10,
                    ),
                    const Flexible(
                      child: Text(
                        "An app for viewing the schedule and more",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(
                  flex: 7,
                ),
                ElevatedButton(
                  onPressed: () {
                    changePage();
                  },
                  child: const Text("Get started..."),
                ),
                const Spacer(
                  flex: 1,
                )
              ],
            );
          }
      ),
    );
  }
}