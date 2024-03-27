import 'package:flutter/material.dart';
import 'package:salonbookingapp/selection.dart';

import '../colors/app_colors.dart';

class SalonSplashScreen extends StatefulWidget {
  const SalonSplashScreen({Key? key}) : super(key: key);

  @override
  State<SalonSplashScreen> createState() => _SalonSplashScreenState();
}

class _SalonSplashScreenState extends State<SalonSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _photoAnimationController;
  late Animation<double> _photoAnimation;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _photoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _photoAnimation = Tween<double>(begin: -50, end: 20).animate(
      CurvedAnimation(
        parent: _photoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _photoAnimationController.forward();

    // Delay fade-in animation after photo animation
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _photoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _photoAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: Offset(0, _photoAnimation.value),
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/icons/salon logo.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 130,
            left: 50,
            right: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'DentalFont', // Use a custom dental font
                    fontWeight: FontWeight.bold,
                    color: AppColors.baseColor,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Salon App',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Cleansing',
                    fontWeight: FontWeight.bold,
                    color: AppColors.blueColor,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => RegisterSelectionPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.baseColor,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
