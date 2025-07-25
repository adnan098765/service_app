import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';
import '../Controlller/otp_controller.dart';
import 'authentication_screen.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  final int customerId;
  final String? token;
  final String? actualOtp;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.customerId,
    this.token,
    this.actualOtp,
  });

  String _formatPhoneNumber(String phone) {
    return phone.length == 10 ? '+92$phone' : phone;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('OtpScreen initialized with phoneNumber: $phoneNumber, customerId: $customerId, token: $token, actualOtp: $actualOtp');

    final OtpController controller = Get.put(OtpController());
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
          onPressed: () => Get.back(),
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
                text: _formatPhoneNumber(phoneNumber),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.appColor,
              ),
              if (actualOtp != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Test OTP: $actualOtp (SMS may take time to deliver)',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Center(
                child: Pinput(
                  length: 4,
                  controller: controller.otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.appColor),
                    ),
                  ),
                  showCursor: true,
                  onCompleted: (pin) {
                    debugPrint('Entered OTP: $pin');
                    controller.verifyOtpAlternative(phoneNumber, customerId, token, actualOtp);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMS Troubleshooting:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Check your spam/junk messages\n'
                          '• Ensure good network coverage\n'
                          '• SMS may take 1-5 minutes to deliver\n'
                          '• Try resending if not received',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() => TextButton(
                  onPressed: controller.isResendEnabled.value
                      ? () {
                    debugPrint('Resending OTP for: $phoneNumber');
                    controller.resendOtp(phoneNumber);
                  }
                      : null,
                  child: Text(
                    controller.isResendEnabled.value
                        ? "Resend OTP"
                        : "Resend in ${controller.secondsRemaining.value} s",
                    style: TextStyle(
                      color: controller.isResendEnabled.value
                          ? AppColors.appColor
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 30),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    debugPrint('Verify button pressed');
                    controller.verifyOtpAlternative(phoneNumber, customerId, token, actualOtp);
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const CustomText(
                    text: "Verify",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
              const SizedBox(height: 20),
              const Center(
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