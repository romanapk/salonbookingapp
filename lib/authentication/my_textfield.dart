import 'package:flutter/material.dart';

import '../Utils/app_style.dart';

class MyTextField extends StatelessWidget {

  final controller;
  final IconData? data;
  final String hintText;
  final bool obscureText;
  bool? enabled = true;


   MyTextField({
    super.key,
    required this.controller,
    this.data,
    required this.hintText,
    required this.obscureText,
    this.enabled,



  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Styles.darkColor),
            ),
            prefixIcon: Icon(
              data,
              color: Styles.orangeColor, // Set icon color
            ),

            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlueAccent),
            ),
            fillColor: Styles.bgColor,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Styles.textColor,
            )

        ),
      ),
    );
  }
}
