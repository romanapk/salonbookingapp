import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:salonbookingapp/splash_screen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'colors/app_colors.dart';
import 'global/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Student_Record');

  sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAiFRxlL5Nnq-Kl6FFvknTXe3w3P4UI7ys",
        appId: "1:719830039728:android:64e1a92bb13346b1c00f75",
        messagingSenderId: "719830039728 ",
        projectId: "fyp-fb-fbdb4",
        storageBucket: "gs://fyp-fb-fbdb4.appspot.com"),
  );

  GeocodingPlatform.instance?.locationFromAddress("New York");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salon App',
      theme: ThemeData(
        primaryColor: AppColors.darkerColor,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff4B2EAD)),
        useMaterial3: true,
      ),
      //home: AppShell(),
      //home: ManagerLoginView(),
      home: SalonSplashScreen(),
      //home: Home(),
    );
  }
}
