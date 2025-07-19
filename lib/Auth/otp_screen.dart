import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/Auth/authentication_screen.dart';
import 'package:untitled2/widgets/custom_text.dart';
class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  final int customerId;
  final String? token; // Make token optional

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.otp,
    required this.customerId,
    this.token, // Optional token
  });

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
    print('[log] OTP for verification: ${widget.otp}, Customer ID: ${widget.customerId}, Token: ${widget.token}');
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
      _startTimer();
      Get.snackbar(
        'OTP Resent',
        'A new OTP has been sent (mocked)',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.appColor,
        colorText: AppColors.whiteTheme,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.length != 4) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a 4-digit OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: AppColors.whiteTheme,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (_otpController.text == widget.otp) {
      Get.snackbar(
        'Success',
        '✅ OTP Verified Successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: AppColors.whiteTheme,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );
      // Use customerId and token for next steps (e.g., login or profile update)
      print('Verified - Customer ID: ${widget.customerId}, Token: ${widget.token}');
      // Navigate to next screen or perform login
    } else {
      Get.snackbar(
        'Error',
        '❌ Invalid OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: AppColors.whiteTheme,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      );
    }
  }

  String _formatPhoneNumber(String phone) {
    return phone.length == 10 ? '+92$phone' : phone;
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
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        child: SingleChildScrollView(
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isResendEnabled ? _resendOtp : null,
                  child: Text(
                    _isResendEnabled
                        ? "Resend OTP"
                        : "Resend in $_secondsRemaining s",
                    style: TextStyle(
                      color: _isResendEnabled
                          ? AppColors.appColor
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                  onPressed: (){
                    _verifyOtp;
                    Get.to(AuthenticationScreen());
                  },
                  child: const CustomText(
                    text: "Verify",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Didn't receive code? Check your spam folder",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pinput/pinput.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
// import 'package:untitled2/widgets/custom_text.dart';
// import 'authentication_screen.dart';
//
// class OtpScreen extends StatefulWidget {
//   final String phoneNumber;
//   String verificationId; // Mutable to allow updating on resend
//
//   OtpScreen({super.key, required this.phoneNumber, required this.verificationId});
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   int _secondsRemaining = 30;
//   late Timer _timer;
//   bool _isResendEnabled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//     print('Received phone number: ${widget.phoneNumber}'); // Debug log
//   }
//
//   void _startTimer() {
//     _secondsRemaining = 30;
//     _isResendEnabled = false;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_secondsRemaining > 0) {
//         setState(() => _secondsRemaining--);
//       } else {
//         timer.cancel();
//         setState(() => _isResendEnabled = true);
//       }
//     });
//   }
//
//   Future<void> _resendOtp() async {
//     if (_isResendEnabled) {
//       setState(() {
//         _isResendEnabled = false;
//         _secondsRemaining = 30;
//       });
//       try {
//         await FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: '+92${widget.phoneNumber}', // Add +92 for Firebase
//           verificationCompleted: (PhoneAuthCredential credential) {},
//           verificationFailed: (FirebaseAuthException ex) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(ex.message ?? "Failed to resend OTP")),
//             );
//           },
//           codeSent: (String newVerificationId, int? resendToken) {
//             setState(() {
//               widget.verificationId = newVerificationId; // Update verificationId
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('OTP resent successfully')),
//             );
//             _startTimer();
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {},
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Something went wrong while resending OTP')),
//         );
//       }
//     }
//   }
//
//   Future<void> _verifyOtp() async {
//     if (_otpController.text.length != 4) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a 4-digit OTP')),
//       );
//       return;
//     }
//
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: _otpController.text.trim(),
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const AuthenticationScreen(),
//         ),
//       );
//     } catch (ex) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Verification failed: ${ex.toString()}')),
//       );
//     }
//   }
//
//   String _formatPhoneNumber(String phone) {
//     if (phone.length == 10) {
//       // Concatenate +92 with the 10-digit number without space
//       return '+92$phone';
//     }
//     return phone; // Return as-is if not 10 digits
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _otpController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 60,
//       textStyle: const TextStyle(
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               CustomText(
//                 text: "OTP Verification",
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.appColor,
//               ),
//               const SizedBox(height: 10),
//               const CustomText(
//                 text: "We've sent a 4-digit verification code to",
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//               const SizedBox(height: 5),
//               CustomText(
//                 text: _formatPhoneNumber(widget.phoneNumber),
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.appColor,
//               ),
//               const SizedBox(height: 40),
//               Center(
//                 child: Pinput(
//                   length: 4, // Keep 4-digit OTP
//                   controller: _otpController,
//                   defaultPinTheme: defaultPinTheme,
//                   focusedPinTheme: defaultPinTheme.copyWith(
//                     decoration: defaultPinTheme.decoration!.copyWith(
//                       border: Border.all(color: AppColors.appColor),
//                     ),
//                   ),
//                   showCursor: true,
//                   onCompleted: (pin) => _verifyOtp(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: _isResendEnabled ? _resendOtp : null,
//                   child: Text(
//                     _isResendEnabled ? "Resend OTP" : "Resend in $_secondsRemaining s",
//                     style: TextStyle(
//                       color: _isResendEnabled ? AppColors.appColor : Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.buttonColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: _verifyOtp,
//                   child: const CustomText(
//                     text: "Verify",
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Center(
//                 child: Text(
//                   "Didn't receive code? Check your spam folder",
//                   style: TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }