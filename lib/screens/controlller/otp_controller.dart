import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_urls.dart';
import '../auth/authentication_screen.dart';
import '../auth/otp_screen.dart';
import '../models/send_otp_model.dart';

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  var secondsRemaining = 30.obs;
  var isResendEnabled = false.obs;
  var isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    debugPrint("🟢 [OtpController] Initialized");
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    debugPrint("🧹 [OtpController] Disposed");
    super.onClose();
  }

  void startTimer() {
    secondsRemaining.value = 30;
    isResendEnabled.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
        isResendEnabled.value = true;
      }
    });
    debugPrint("⏲️ [OtpController] Timer started");
  }

  Future<void> resendOtp(String phoneNumber) async {
    if (!isResendEnabled.value) {
      debugPrint("⏳ [OtpController] Resend OTP called too soon for $phoneNumber");
      return;
    }

    isLoading.value = true;
    debugPrint("📡 [OtpController] Resending OTP to +92$phoneNumber");
    try {
      final response = await http
          .post(
            Uri.parse(AppUrls.sendOtp),
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode({'mobile': '+92$phoneNumber', 'country_code': '+92', 'message_type': 'sms'}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Resend OTP request timed out');
            },
          );

      debugPrint('📥 [OtpController] Resend OTP Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final sendOtpModel = SendOtpModel.fromJson(jsonDecode(response.body));
        if (sendOtpModel.success == true) {
          Get.snackbar(
            'Success',
            'New OTP sent successfully. Check the screen for testing OTP.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          startTimer();
          debugPrint("📲 [OtpController] Navigating to OtpScreen with new OTP for $phoneNumber");
          Get.off(
            () => OtpScreen(
              phoneNumber: phoneNumber,
              customerId: Get.arguments['customerId'] ?? 0,
              actualOtp: sendOtpModel.oTP,
              token: Get.arguments['token'],
            ),
          );
        } else {
          Get.snackbar(
            'Error',
            sendOtpModel.message ?? 'Failed to resend OTP',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Server error occurred while resending OTP: Status ${response.statusCode}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('💥 [OtpController] Exception during resend OTP: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String phoneNumber, int customerId, String? token) async {
    if (otpController.text.length != 4) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a 4-digit OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    debugPrint("🔍 [OtpController] Verifying OTP: ${otpController.text} for +92$phoneNumber");
    try {
      final response = await http
          .post(
            Uri.parse(AppUrls.sendOtp),
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode({'mobile': '+92$phoneNumber', 'otp': otpController.text, 'customer_id': customerId}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('OTP verification request timed out');
            },
          );

      debugPrint('📥 [OtpController] Verify OTP Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          Get.snackbar(
            'Success',
            '✅ OTP Verified Successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          debugPrint("📲 [OtpController] Navigating to AuthenticationScreen with phone: $phoneNumber");
          Get.off(
            () => AuthenticationScreen(
              customerId: customerId,
              token: responseData['token'] ?? token,
              phoneNumber: phoneNumber,
            ),
          );
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? '❌ Invalid OTP',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          '❌ OTP Verification Failed: Status ${response.statusCode}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('💥 [OtpController] Exception during OTP verification: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtpAlternative(String phoneNumber, int customerId, String? token, String? actualOtp) async {
    if (otpController.text.length != 4) {
      Get.snackbar(
        'Invalid Input',
        'Please enter a 4-digit OTP',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    debugPrint("🔍 [OtpController] Verifying OTP: ${otpController.text} for +92$phoneNumber (Actual OTP: $actualOtp)");
    try {
      if (actualOtp != null && otpController.text == actualOtp) {
        Get.snackbar(
          'Success',
          '✅ OTP Verified Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        debugPrint(
          "📲 [OtpController] Local OTP verified, navigating to AuthenticationScreen with phone: $phoneNumber",
        );
        Get.off(() => AuthenticationScreen(customerId: customerId, token: token, phoneNumber: phoneNumber));
        return;
      }

      final response = await http
          .post(
            Uri.parse(AppUrls.sendOtp),
            headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
            body: jsonEncode({'mobile': '+92$phoneNumber', 'otp': otpController.text, 'customer_id': customerId}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('OTP verification request timed out');
            },
          );

      debugPrint('📥 [OtpController] Verify OTP Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          Get.snackbar(
            'Success',
            '✅ OTP Verified Successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          debugPrint(
            "📲 [OtpController] API OTP verified, navigating to AuthenticationScreen with phone: $phoneNumber",
          );
          Get.off(
            () => AuthenticationScreen(
              customerId: customerId,
              token: responseData['token'] ?? token,
              phoneNumber: phoneNumber,
            ),
          );
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? '❌ Invalid OTP',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          '❌ OTP Verification Failed: Status ${response.statusCode}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('💥 [OtpController] Exception during OTP verification: $e');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
