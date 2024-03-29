// import 'package:flutter/material.dart';
// import 'package:salonbookingapp/widgets/update_profile.dart';
//
// import '../authentication/auth_screen.dart';
// import '../doctors_dashboard/bottombar_screen.dart';
// import '../global/global.dart';
// import '../scheduling_page/screen_dashboard.dart';
//
// class MyDrawer extends StatelessWidget {
//   const MyDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: [
//           Container(
//             padding: const EdgeInsets.only(top: 25, bottom: 10),
//             child: Column(
//               children: [
//                 //circle avatar in header of drawer
//                 Material(
//                   borderRadius: const BorderRadius.all(Radius.circular(80)),
//                   elevation: 10,
//                   child: Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child: Container(
//                       height: 160,
//                       width: 160,
//                       child: CircleAvatar(
//                         backgroundImage: NetworkImage(
//                             sharedPreferences!.getString("photoUrl")!),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   sharedPreferences!.getString("name")!,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontFamily: "Train",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 12,
//           ),
//           Container(
//             padding: const EdgeInsets.only(top: 1.0),
//             child: Column(
//               children: [
//                 const Divider(
//                   height: 10,
//                   color: Colors.grey,
//                   thickness: 2,
//                 ),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.home,
//                     color: Colors.black,
//                   ),
//                   title: const Text(
//                     "Home",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomeScreen()),
//                     );
//                   },
//                 ),
//                 const Divider(
//                   height: 10,
//                   color: Colors.grey,
//                   thickness: 2,
//                 ),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.reorder,
//                     color: Colors.black,
//                   ),
//                   title: const Text(
//                     "My Schedule",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ScreenDashboard(),
//                       ),
//                     );
//                   },
//                 ),
//                 const Divider(
//                   height: 10,
//                   color: Colors.grey,
//                   thickness: 2,
//                 ),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.access_time,
//                     color: Colors.black,
//                   ),
//                   title: const Text(
//                     "History",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   onTap: () {},
//                 ),
//                 const Divider(
//                   height: 10,
//                   color: Colors.grey,
//                   thickness: 2,
//                 ),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.search,
//                     color: Colors.black,
//                   ),
//                   title: const Text(
//                     "Search",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   onTap: () {},
//                 ),
//                 const Divider(
//                   height: 10,
//                   color: Colors.grey,
//                   thickness: 2,
//                 ),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.edit,
//                     color: Colors.black,
//                   ),
//                   title: const Text(
//                     "Update Profile",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => UpdateProfileScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 const Divider(
//                   height: 10,
//                   color: Colors.grey,
//                   thickness: 2,
//                 ),
//                 ListTile(
//                   leading: const Icon(
//                     Icons.exit_to_app,
//                     color: Colors.black,
//                   ),
//                   title: const Text(
//                     "Sign Out",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   onTap: () {
//                     firebaseAuth.signOut().then((value) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (c) => const AuthScreen(),
//                         ),
//                       );
//                     });
//                   },
//                 ),
//                 const Divider(
//                   height: 10,
//                   color: Colors.grey,
//                   thickness: 2,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
