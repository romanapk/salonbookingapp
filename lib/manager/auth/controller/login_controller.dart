import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerLoginController extends GetxController {
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLoggedIn = false;

  loginManager(context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        var snapshot = await FirebaseFirestore.instance
            .collection('managers')
            .doc(emailController.text)
            .get();
        if (snapshot.exists &&
            snapshot.data()?['password'] == passwordController.text) {
          isLoggedIn = true;
          Get.snackbar("Success", "Login Successful");
        } else {
          Get.snackbar("Error", "Invalid credentials");
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        Get.snackbar("Error", "Error logging in");
      }
    }
  }

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }
}
