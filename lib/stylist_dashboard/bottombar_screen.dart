import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:salonbookingapp/stylist_dashboard/profile_setup.dart';

import '../colors/app_colors.dart';
import '../scheduling_page/scheduling_page.dart';
import 'home_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.baseColor,
        title: const Text('Dental Appointment App'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const HomePage(),
          SchedulingPage(),
          const HomeScreen(),
          DoctorProfileSetupScreen(),
          // const MyDrawer(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppColors.baseColor,
        color: Colors.white, // Set the icon color
        height: 50,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.calendar_today, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
