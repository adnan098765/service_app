// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:untitled2/screens/Auth/authentication_screen.dart';
// import 'package:untitled2/screens/bottom_nav_bar/bottom_nav_screen.dart';
//
// import '../screens/Auth/enter_phone_number.dart';
// import '../screens/onboardings/onboarding_screen.dart';
// import '../shared_prefs/shared_preference.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   final box = GetStorage();
//   bool _navigated = false;
//   final SharedPrefServices prefs = SharedPrefServices();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
//
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _controller.forward();
//
//     Timer(const Duration(seconds: 3), () async {
//       if (_navigated) return;
//       _navigated = true;
//
//       // Check for auth token first
//       String? authToken = await SharedPrefServices.getAuthToken();
//
//       if (authToken != null && authToken.isNotEmpty) {
//         // Token exists, navigate to BottomNavigationScreen
//         debugPrint("🔑 [SplashScreen] Auth token found, navigating to BottomNavigationScreen");
//         Get.offAll(() => const BottomNavScreen());
//         return;
//       }
//
//       // No token found, continue with existing flow
//       debugPrint("❌ [SplashScreen] No auth token found, continuing with authentication flow");
//
//       bool hasSeenOnboarding = box.read('hasSeenOnboarding') ?? false;
//       bool isLoggedIn = box.read('isLoggedIn') ?? false;
//
//       if (hasSeenOnboarding && isLoggedIn) {
//         int? customerId = await SharedPrefServices.getUserId();
//         if (customerId != null) {
//           Get.offAll(() => AuthenticationScreen(customerId: customerId));
//         } else {
//           Get.offAll(() => const EnterPhoneNumber());
//         }
//       } else if (hasSeenOnboarding && !isLoggedIn) {
//         Get.offAll(() => const EnterPhoneNumber());
//       } else {
//         Get.offAll(() => const OnboardingScreen());
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: FadeTransition(
//           opacity: _animation,
//           child: Image.asset('assets/images/Gee hazir jnab-01.png', width: 150, height: 150),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled2/screens/Auth/authentication_screen.dart';
import 'package:untitled2/screens/bottom_nav_bar/bottom_nav_screen.dart';
import 'package:untitled2/screens/Auth/enter_phone_number.dart';
import 'package:untitled2/screens/onboardings/onboarding_screen.dart';
import 'package:untitled2/shared_prefs/shared_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final _storage = GetStorage();
  final _prefs = SharedPrefServices();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startNavigationTimer();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        debugPrint('✅ Splash animation completed');
      }
    });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  void _startNavigationTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (_isDisposed) return;

      try {
        await _handleNavigation();
      } catch (e) {
        debugPrint('⚠️ Error during navigation: $e');
        _navigateToOnboarding(); // Fallback navigation
      }
    });
  }

  Future<void> _handleNavigation() async {
    final authToken = await SharedPrefServices.getAuthToken();

    if (authToken != null && authToken.isNotEmpty) {
      debugPrint('🔑 User has auth token, navigating to home');
      _navigateToHome();
      return;
    }

    debugPrint('🔐 No auth token found, checking onboarding status');
    final hasSeenOnboarding = _storage.read('hasSeenOnboarding') ?? false;
    final isLoggedIn = _storage.read('isLoggedIn') ?? false;

    if (!hasSeenOnboarding) {
      debugPrint('🆕 First launch, showing onboarding');
      _navigateToOnboarding();
      return;
    }

    if (isLoggedIn) {
      final customerId = await SharedPrefServices.getUserId();
      if (customerId != null) {
        debugPrint('👤 Logged in user found, navigating to authentication');
        _navigateToAuthentication(customerId);
      } else {
        debugPrint('📱 No user ID found, navigating to phone number input');
        _navigateToPhoneNumber();
      }
    } else {
      debugPrint('📱 User not logged in, navigating to phone number input');
      _navigateToPhoneNumber();
    }
  }

  void _navigateToHome() {
    if (_isDisposed) return;
    Get.offAll(() => const BottomNavScreen());
  }

  void _navigateToOnboarding() {
    if (_isDisposed) return;
    Get.offAll(() => const OnboardingScreen());
  }

  void _navigateToPhoneNumber() {
    if (_isDisposed) return;
    Get.offAll(() => const EnterPhoneNumber());
  }

  void _navigateToAuthentication(int customerId) {
    if (_isDisposed) return;
    Get.offAll(() => AuthenticationScreen(customerId: customerId));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Image.asset(
            'assets/images/art work.jpg',
            fit: BoxFit.cover,
          ),

          // Centered logo with fade animation
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/images/Gee hazir jnab-01.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}