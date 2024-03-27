import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: ContactUs(
        cardColor: Colors.white,
        textColor: Colors.teal.shade900,
        logo: const AssetImage('images/logo.jpg'),
        email: 'romanatahir420@gmail.com',
        companyName: '',
        companyColor: Colors.teal.shade100,
        dividerThickness: 2,
        phoneNumber: '+923145226837',
        website: '',
        linkedinURL: '',
        tagLine: 'Salon App',
        taglineColor: Colors.teal.shade100,
        instagram: '',
        facebookHandle: '',
      ),
    );
  }
}
