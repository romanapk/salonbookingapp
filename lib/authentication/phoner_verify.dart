import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utils/app_style.dart';
import '../customer_dashboard/bottombar_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';

  Future<void> verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+92${_phoneNumberController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("Sign in Successful");
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String? verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId!;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void signInWithOTP(BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
      );

      _phoneNumberController.clear();
      _otpController.clear();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(40.10),
              child: TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  iconColor: Styles.bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Styles.orangeColor),
                  //   borderRadius: BorderRadius.circular(9),
                  //
                  // ),
                  labelText: 'Enter Phone Number',
                  prefixIcon: const Icon(
                    Icons.phone,
                  ),
                  filled: true,
                  fillColor: Styles.textColor,
                  focusColor: Styles.textColor,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: verifyPhoneNumber,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Styles.orangeColor),
              ),
              label: const Text(
                'Send OTP',
                style: TextStyle(color: Styles.textColor),
              ),
              icon: const Icon(Icons.access_time, color: Styles.textColor),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Styles.orangeColor),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  labelText: 'Enter OTP',
                  prefixIcon: const Icon(Icons.numbers_rounded),
                  filled: true,
                  fillColor: Styles.textColor,
                  focusColor: Styles.textColor,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: verifyPhoneNumber,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Styles.orangeColor),
              ),
              label: const Text(
                'Sign In',
                style: TextStyle(color: Styles.textColor),
              ),
              icon: const Icon(Icons.home),
            ),
          ],
        ),
      ),
    );
  }
}
