import 'package:flutter/material.dart';

import '../Auth/authentication_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/img.png",
      "heading": "Mahir home care",
      "text": "Get verified technician at your doorstep in 60 mins."
    },
    {
      "image": "assets/images/img.png",
      "heading": "Mahir Personal Care",
      "text": "Relish expert services with branded products in the comfort of your home."
    }
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthenticationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              onboardingData[currentPage]["image"]!,
              fit: BoxFit.cover,
            ),
          ),

          // Bottom Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    onboardingData[currentPage]["heading"]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    onboardingData[currentPage]["text"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [

                      Row(
                        children: List.generate(
                          onboardingData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: currentPage == index ? 20 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: currentPage == index ? Colors.black : Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Next Button
                      ElevatedButton(
                        onPressed: nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(currentPage == onboardingData.length - 1
                            ? "Next"
                            : "Next"),
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
}
