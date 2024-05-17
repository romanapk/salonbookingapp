import 'package:flutter/material.dart';

class LoadingDialoge extends StatelessWidget {
  final String? message;
  const LoadingDialoge({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        // circularProgress(),
          const SizedBox(
            height: 10,
          ),
          // ignore: prefer_interpolation_to_compose_strings
          Text(message! + ", Authenticating..."),
        ],
      ),
    );
  }
}