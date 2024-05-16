import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key, required this.textController, required this.submitFunction});

  final TextEditingController textController;
  final Function submitFunction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: "Input number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  submitFunction();
                },
                child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
