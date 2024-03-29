import 'package:flutter/material.dart';

import '../Utils/app_style.dart';
import '../admin_dashboard/category/view/category_view.dart';
import 'image_slider.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Container(
          decoration: BoxDecoration(
            color: Styles.orangeColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(top: 0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.waving_hand,
                      color: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          const ImageSlider(),
          const SizedBox(height: 8),
          Container(
            height: 500, // Set a fixed height for the SearchScreen
            child: CategoryScreenn(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
