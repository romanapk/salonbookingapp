import 'package:flutter/material.dart';

import '../../colors/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textController;
  final IconData? icon;
  final String? hint;
  final FormFieldValidator<String>? validator;

  CustomTextField({
    Key? key,
    this.textController,
    this.icon,
    this.hint,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: textController,
        obscureText:
            false, // You can set this to true if you want it to be obscure
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(color: AppColors.baseColor),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: AppColors.baseColor,
          ),
          filled: true,
          fillColor: Colors.grey,
          focusColor: Theme.of(context).primaryColor,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.greenAccent[500],
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.baseColor),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
