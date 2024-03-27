// import 'package:flutter/material.dart';
// import 'package:salon/authentication/register.dart';
// import '../doctors_dashboard/bottombar_screen.dart';
// import '../front_screens/app_shell.dart';
//
// class RegisterSelectionPage extends StatefulWidget {
//   @override
//   _RegisterSelectionPageState createState() => _RegisterSelectionPageState();
// }
//
// class _RegisterSelectionPageState extends State<RegisterSelectionPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Show dialog with registration options
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Register As'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 ListTile(
//                   title: const Text('Doctor'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to Doctor Registration Page
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const RegisterScreen()),
//                     ).then((value) {
//                       if (value == true) {
//                         // Navigate to HomeScreen if registration as a doctor is successful
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const HomeScreen()),
//                         );
//                       }
//                     });
//                   },
//                 ),
//                 ListTile(
//                   title: Text('Patient'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate to Patient Registration Page
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const RegisterScreen()),
//                     ).then((value) {
//                       if (value == true) {
//                         // Navigate to PatientHomeScreen if registration as a patient is successful
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const AppShell()),
//                         );
//                       }
//                     });
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(),
//     );
//   }
// }
