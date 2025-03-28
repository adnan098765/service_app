import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';
import 'authentication_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = 30;
  late Timer _timer;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _isResendEnabled = true);
      }
    });
  }

  void _resendOtp() {
    if (_isResendEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
      _startTimer();
    }
  }

  void _verifyOtp() {
    if (_otpController.text.length == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthenticationScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 4-digit OTP')),
      );
    }
  }

  String _formatPhoneNumber(String phone) {
    if (phone.length >= 4) {
      return '+92 ${phone.substring(1, 4)} ${phone.substring(4)}';
    }
    return phone;
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomText(
              text: "OTP Verification",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.appColor,
            ),
            const SizedBox(height: 10),
            const CustomText(
              text: "We've sent a 4-digit verification code to",
              fontSize: 16,
              color: Colors.grey,
            ),
            const SizedBox(height: 5),
            CustomText(
              text: _formatPhoneNumber(widget.phoneNumber),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.appColor,
            ),
            const SizedBox(height: 40),

            // 4-digit OTP input
            Center(
              child: Pinput(
                length: 4,
                controller: _otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: AppColors.appColor),
                  ),
                ),
                showCursor: true,
                onCompleted: (pin) => _verifyOtp(),
              ),
            ),
            const SizedBox(height: 20),

            // Resend OTP
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isResendEnabled ? _resendOtp : null,
                child: Text(
                  _isResendEnabled ? "Resend OTP" : "Resend in $_secondsRemaining s",
                  style: TextStyle(
                    color: _isResendEnabled ? AppColors.appColor : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _verifyOtp,
                child: const CustomText(
                  text: "Verify",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),

            const Center(
              child: Text(
                "Didn't receive code? Check your spam folder",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}