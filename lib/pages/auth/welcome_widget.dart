import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.changePage});

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
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Diary",
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                  //textAlign: TextAlign.left,
                ),
                const Text(
                  "An app for viewing the schedule and more",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3),
                ),
              ]
                  .animate(interval: 600.ms)
                  .fadeIn(duration: 900.ms, delay: 300.ms)
                  .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad),
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
          ).animate(delay: 1500.ms).fadeIn(),
          const Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }
}
