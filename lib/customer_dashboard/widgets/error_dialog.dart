import 'package:flutter/material.dart';

class ErrorDialoge extends StatelessWidget {
  final String? message;
  const ErrorDialoge({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          child: const Center(
            child: Text("OK"),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}