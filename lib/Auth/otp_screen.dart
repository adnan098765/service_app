import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';
import '../BottomNavBar/bottom_nav_screen.dart';
import '../widgets/custom_container.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  int _secondsRemaining = 30;
  late Timer _timer;
  bool isResendEnabled = false;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 30;
    isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          isResendEnabled = true;
        });
      }
    });
  }

  void resendOTP() {
    if (isResendEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP resent to your number'),
          duration: Duration(seconds: 2),
        ),
      );
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),
              Hero(
                tag: 'otp-title',
                child: Material(
                  color: Colors.transparent,
                  child: CustomText(
                    text: "OTP Verification",
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appColor,
                  ),
                ),
              ),

              SizedBox(height: height * 0.01),
              CustomText(
                text: "We've sent a verification code to",
                fontSize: 16,
                color: AppColors.appColor,
              ),
              SizedBox(height: 4),
              CustomText(
                text: "+923260483582",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.appColor,
              ),

              SizedBox(height: height * 0.04),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18, letterSpacing: 2),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.appColor, width: 2),
                    ),
                    hintText: "Enter 6-digit OTP",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.appColor),
                    suffixIcon: InkWell(
                      onTap: resendOTP,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12,top: 12),
                        child: Text(
                          isResendEnabled ? "Resend" : "$_secondsRemaining s",
                          style: TextStyle(
                            color: isResendEnabled ? AppColors.appColor : AppColors.greyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              // Email option
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {

                  },
                  child: CustomText(
                    text: "Send code via Email?",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlueShade,
                  ),
                ),
              ),

              SizedBox(height: height * 0.05),

              // Verify Button with press effect
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _isButtonPressed = true),
                  onTapUp: (_) => setState(() => _isButtonPressed = false),
                  onTapCancel: () => setState(() => _isButtonPressed = false),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavScreen()),
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: height * 0.065,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.buttonColor,
                          AppColors.buttonColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: _isButtonPressed
                          ? []
                          : [
                        BoxShadow(
                          color: AppColors.buttonColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomText(
                        text: "Verify",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.05),

              // Illustration
              Center(
                child: Image.asset(
                  "assets/images/Gee hazir jnab-01.png",
                  height: height * 0.35,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: height * 0.02),

              // Help text
              Center(
                child: Text(
                  "Didn't receive code? Check your spam folder",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}