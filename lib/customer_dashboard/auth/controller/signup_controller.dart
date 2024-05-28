import 'dart:developer';

import '../../../stylist_dashboard/general/consts/consts.dart';

class SignupController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  UserCredential? userCredential;
  var isLoading = false.obs;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
    }
  }

  Future<void> updateUser(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        var user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updateEmail(emailController.text);
          await user.updatePassword(passwordController.text);
          await user.updateDisplayName(nameController.text);
          var store =
              FirebaseFirestore.instance.collection('users').doc(user.uid);
          await store.update({
            'fullname': nameController.text,
            'email': emailController.text,
          });
          VxToast.show(context, msg: "Profile Updated Successfully");
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        VxToast.show(context, msg: "Failed to update profile");
        log("$e");
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signupUser(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential != null) {
          var store = FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential!.user!.uid);
          await store.set({
            'uid': userCredential!.user!.uid,
            'fullname': nameController.text,
            'password': passwordController.text,
            'email': emailController.text,
          });
          VxToast.show(context, msg: "Signup Successful");
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            VxToast.show(context, msg: "Already have an account");
          } else {
            VxToast.show(context, msg: "No internet connection");
          }
        } else {
          VxToast.show(context, msg: "Try after some time");
        }
        log("$e");
      }
    }
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  String? validateemail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validpass(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one capital letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return 'Password must contain at least one special character (!@#\$&*~)';
    }
    RegExp passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return 'Your password must contain at least 8 characters';
    }
    return null;
  }

  String? validname(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a name';
    }
    RegExp nameRegExp = RegExp(r'^.{5,}$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }
}
