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
      child: Column(
        children: [
          const Spacer(
            flex: 4,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Diary",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                  //textAlign: TextAlign.left,
                ),
                Text(
                  "An app for viewing the schedule and more",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}