import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonbookingapp/splash_screen/splashscreen.dart';
import 'package:salonbookingapp/stylist_dashboard/general/consts/colors.dart';
import 'package:salonbookingapp/stylist_dashboard/notifications/stylist_notifications.dart';

import '../stylist_profile/profilescreen.dart';

class StylistDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<User?>(
            future: _getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primeryColor,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primeryColor,
                  ),
                  child: Text(
                    'Hi User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                );
              } else {
                User? user = snapshot.data;
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.primeryColor,
                  ),
                  child: Text(
                    'Hi ${user!.displayName ?? 'User'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Get.to(() => StylistProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Get.to(() => StylistNotificationsPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => SalonSplashScreen());
            },
          ),
        ],
      ),
    );
  }

  Future<User?> _getUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
