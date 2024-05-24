import 'package:flutter/material.dart';
import 'package:salonbookingapp/stylist_dashboard/auth/view/login_page.dart';

import '../front_screens/app_shell.dart';
import 'customer_dashboard/auth/view/login_page.dart';
import 'customer_dashboard/home/view/home_screen.dart';

class RegisterSelectionPage extends StatefulWidget {
  @override
  _RegisterSelectionPageState createState() => _RegisterSelectionPageState();
}

class _RegisterSelectionPageState extends State<RegisterSelectionPage> {
  @override
  void initState() {
    super.initState();
    // Show dialog with registration options
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('I am a'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Text('Stylist'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to Doctor Registration Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginVieww()),
                    ).then((value) {
                      if (value == true) {
                        // Navigate to HomeScreen if registration as a doctor is successful
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                    });
                  },
                ),
                ListTile(
                  title: Text('Customer'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to Patient Registration Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    ).then((value) {
                      if (value == true) {
                        // Navigate to PatientHomeScreen if registration as a patient is successful
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppShell()),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
