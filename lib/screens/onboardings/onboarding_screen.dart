import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled2/screens/Auth/enter_phone_number.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  double _currentPosition = 0.0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/img.png",
      "heading": "Mahir Home Care",
      "text": "Get verified technician at your doorstep in 60 mins.",
      "color": "#075095"
    },
    {
      "image": "assets/images/img.png",
      "heading": "Mahir Personal Care",
      "text": "Relish expert services with branded products in the comfort of your home.",
      "color": "#075095"
    }
  ];

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
    _pageController.addListener(() {
      setState(() {
        _currentPosition = _pageController.page!;
      });
    });
  }

  Future<void> _checkOnboardingStatus() async {
    final box = GetStorage();
    bool hasSeenOnboarding = box.read('hasSeenOnboarding') ?? false;
    if (hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const EnterPhoneNumber(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentPage++;
      });
    } else {
      _markOnboardingAsSeen();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const EnterPhoneNumber(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  Future<void> _markOnboardingAsSeen() async {
    final box = GetStorage();
    await box.write('hasSeenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(onboardingData[currentPage]["color"]!.substring(1, 7), radix: 16) + 0xFF000000);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.5), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final scale = 1 - (_currentPosition - index).abs() * 0.3;
              return Transform.scale(
                scale: scale.clamp(0.8, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: 'onboarding-image-$index',
                        child: Image.asset(
                          onboardingData[index]["image"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 30.h,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      onboardingData[currentPage]["heading"]!,
                      key: ValueKey<String>(onboardingData[currentPage]["heading"]!),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      onboardingData[currentPage]["text"]!,
                      key: ValueKey<String>(onboardingData[currentPage]["text"]!),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          onboardingData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentPage == index ? color : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      FloatingActionButton(
                        onPressed: nextPage,
                        backgroundColor: color,
                        elevation: 0,
                        child: Icon(
                          currentPage == onboardingData.length - 1 ? Icons.check : Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}