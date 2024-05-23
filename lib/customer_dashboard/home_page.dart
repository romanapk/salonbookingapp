import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/app_style.dart';
import '../stylist_dashboard/total_appintment/view/accepted_appointments_page.dart';
import '../stylist_dashboard/total_appintment/view/pending_appointments_page.dart';
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
                  "APPOINTMENTS",
                  style: TextStyle(
                    color: Styles.orangeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all(Styles.orangeColor),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const Home()),
                //     );
                //   },
                //   child: const Text(
                //     "Your Total Appointments",
                //     style: TextStyle(
                //       color: Styles.textColor,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Styles.orangeColor),
                  ),
                  onPressed: () {
                    Get.to(PendingAppointmentsPage());
                  },
                  child: const Text(
                    "Pending Appointments",
                    style: TextStyle(
                      color: Styles.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Styles.orangeColor),
                  ),
                  onPressed: () {
                    Get.to(AcceptedAppointmentsPage());
                  },
                  child: const Text(
                    "Accepted Appointments",
                    style: TextStyle(
                      color: Styles.textColor,
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
