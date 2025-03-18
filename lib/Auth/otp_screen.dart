import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';

import '../BottomNavigation/bottom_nav_screen.dart';
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

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 30; // Reset timer
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
      print("OTP Resent!");
      startTimer(); // Restart timer
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
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.030),
            const CustomText(
              text: "OTP verification",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: height * 0.010),
            const CustomText(
              text: "Code will be sent on +923260483582",
              fontSize: 14,
            ),
            SizedBox(height: height * 0.020),

            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade300,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.lightWhite, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.lightWhite, width: 1),
                ),
                hintText: "Enter OTP",
                suffixText:
                    isResendEnabled
                        ? "Resend OTP"
                        : "Resend in $_secondsRemaining s",
                suffixStyle: TextStyle(
                  fontSize: 14,
                  color: isResendEnabled ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: height*0.012,),
            CustomText(text: "Send code on Email?",fontSize: 14,fontWeight: FontWeight.bold,color: AppColors.blackColor,),
            SizedBox(height: height*0.1,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavScreen()));
              },
              child: CustomContainer(
                height: height*0.0550,
                width: width,
                color: AppColors.blackColor,
                borderRadius: 15,
                child: Center(child: CustomText(text: "Verify",fontSize: 18,fontWeight: FontWeight.bold,color: AppColors.whiteTheme,)),
              ),
            ),
            Image(image: AssetImage("assets/images/img_1.png"))
          ],
        ),
      ),
    );
  }
}
