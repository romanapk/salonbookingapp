import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salonbookingapp/authentication/phoner_verify.dart';
import 'package:salonbookingapp/authentication/register.dart';

import '../Utils/app_style.dart';
import '../admin_dashboard/bottombar_screen.dart';
import '../front_screens/app_shell.dart';
import 'auth_services.dart';
import 'my_button.dart';
import 'my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Method to show a loading dialog
  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Method to dismiss the loading dialog
  void dismissLoadingDialog() {
    Navigator.pop(context);
  }

  // Method to sign in the user with email and password
  void signUserIn() async {
    showLoadingDialog();

    try {
      await AuthService().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      dismissLoadingDialog();

      // Navigate to HomeScreen after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      dismissLoadingDialog();
      handleSignInError(e.code);
    }
  }

  // Method to handle incorrect email or password error
  void handleSignInError(String errorCode) {
    String errorMessage = 'An error occurred';

    if (errorCode == 'user-not-found') {
      errorMessage = 'Email not registered';
    } else if (errorCode == 'wrong-password') {
      errorMessage = 'Incorrect Password';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorMessage),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.textColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 80),
            const Icon(
              Icons.lock,
              size: 70,
              color: Styles.orangeColor,
            ),
            const SizedBox(height: 30),
            const Text(
              'Welcome back you\'ve been missed!',
              style: TextStyle(
                color: Styles.bgColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: emailController,
              hintText: 'Username',
              obscureText: false,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 35),
            MyButton(
              text: "Sign In",
              onTap: signUserIn,
            ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Styles.orangeColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        color: Styles.bgColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Styles.orangeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    UserCredential? userCredential =
                        await AuthService().signInWithGoogle();
                    if (userCredential != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppShell()),
                      );
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Image.asset('assets/images/google.png'),
                  ),
                ),
                const SizedBox(width: 80),
                GestureDetector(
                  onTap: () {
                    // Navigate to PhoneVerificationScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhoneAuthScreen()),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: Image.asset('assets/images/phone1.png'),
                  ),
                ),
                const SizedBox(width: 25),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not a member?',
                  style: TextStyle(color: Styles.orangeColor),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Register Now',
                    style: TextStyle(
                      color: Styles.orangeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
