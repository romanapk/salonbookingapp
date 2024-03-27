import 'package:flutter/material.dart';

class Styles {
  static const Color bgColor = Color(0xFF358597);
  static const Color orangeColor = Color(0xFFE37156);
  static const Color darkColor = Color(0xFFE55A39);

  static const Color textColor = Color(0xFFFFFFFF);

  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: orangeColor,
    );
  }
}