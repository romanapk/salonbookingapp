import 'package:flutter/material.dart';
import 'package:salonbookingapp/doctors_dashboard/home/view/home.dart';

import '../Utils/app_style.dart';
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
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Styles.orangeColor),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => const Home()),
                    );
                  },
                  child: const Text(
                    "Your total Appointments",
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
