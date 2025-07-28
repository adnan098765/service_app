import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled2/Auth/authentication_screen.dart';
import '../Auth/enter_phone_number.dart';
import '../BottomNavBar/bottom_nav_screen.dart';
import '../OnboardingPage/onboarding_screen.dart';
import '../SharedPreference/shared_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final box = GetStorage();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Timer(const Duration(seconds: 3), () async {
      if (_navigated) return;
      _navigated = true;

      bool hasSeenOnboarding = box.read('hasSeenOnboarding') ?? false;
      bool isLoggedIn = box.read('isLoggedIn') ?? false;

      if (hasSeenOnboarding && isLoggedIn) {
        int? customerId = await SharedPreferencesHelper.getUserId();
        if (customerId != null) {
          Get.offAll(() => AuthenticationScreen(customerId: customerId));
        } else {
          Get.offAll(() => const EnterPhoneNumber());
        }
      } else if (hasSeenOnboarding && !isLoggedIn) {
        Get.offAll(() => const EnterPhoneNumber());
      } else {
        Get.offAll(() => const OnboardingScreen());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/images/Gee hazir jnab-01.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
