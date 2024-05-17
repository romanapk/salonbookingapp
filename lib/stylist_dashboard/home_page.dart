import 'package:flutter/material.dart';
import 'package:salonbookingapp/stylist_dashboard/profile_setup.dart';

import '../colors/app_colors.dart';
import 'image_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const ImageSliderss(),
                const SizedBox(height: 20),
                const Text(
                  "Let's build your profile",
                  style: TextStyle(
                    color: AppColors.darkerColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.darkerColor),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) =>
                              const DoctorProfileSetupScreen()),
                    );
                  },
                  child: const Text(
                    "Setup Your Profile",
                    style: TextStyle(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
