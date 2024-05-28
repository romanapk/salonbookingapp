import 'package:flutter/material.dart';

class CoustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? textcontroller;
  final Widget icon;
  final Color? textcolor;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? Function(String?)? validator;

  const CoustomTextField({
    Key? key,
    required this.hint,
    this.textcontroller,
    required this.icon,
    this.textcolor,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textcontroller,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hint,
        hintStyle: TextStyle(color: textcolor),
        border: const OutlineInputBorder(borderSide: BorderSide()),
        prefixText: prefixText,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
