// SchedulingPage.dart
import 'package:flutter/material.dart';
import 'package:salonbookingapp/scheduling_page/screen_dashboard.dart';

class SchedulingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenDashboard(),
    );
  }
}
