import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Auth/otp_screen.dart';
import '../Models/user_created_model.dart';
import '../constants/app_urls.dart';
import '../models/send_otp_model.dart';
import '../DatabaseHelper/database_helper.dart';

class PhoneNumberController extends GetxController {
  final TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isPhoneValid = false.obs;
  var isLoading = false.obs;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void onClose() {
    debugPrint("🧹 [PhoneNumberController] Disposed");
    phoneNumberController.dispose();
    super.onClose();
  }

  void onPhoneChanged(String value) {
    isPhoneValid.value = value.length == 10 && value.startsWith('3');
    debugPrint("📲 [PhoneNumberController] Phone changed: $value → Valid: ${isPhoneValid.value}");
  }

  String _formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    debugPrint("🔧 [PhoneNumberController] Raw phone: $phone → Clean: $cleanPhone");

    if (cleanPhone.length == 10 && cleanPhone.startsWith('3')) {
      debugPrint("✅ [PhoneNumberController] Formatted: +92$cleanPhone");
      return '+92$cleanPhone';
    }
    if (cleanPhone.length == 11 && cleanPhone.startsWith('03')) {
      debugPrint("✅ [PhoneNumberController] Formatted: +92${cleanPhone.substring(1)}");
      return '+92${cleanPhone.substring(1)}';
    }
    if (cleanPhone.startsWith('92') && cleanPhone.length == 12) {
      debugPrint("✅ [PhoneNumberController] Formatted: +$cleanPhone");
      return '+$cleanPhone';
    }

    debugPrint("⚠️ [PhoneNumberController] Default format: +92$cleanPhone");
    return '+92$cleanPhone';
  }

  Future<void> verifyPhoneNumber(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      debugPrint("❌ [PhoneNumberController] Form validation failed");
      return;
    }

    isLoading.value = true;
    final fullPhone = _formatPhoneNumber(phoneNumberController.text.trim());
    debugPrint("🚀 [PhoneNumberController] Verifying phone: $fullPhone");

    try {
      /// STEP 1: Check/Create User
      debugPrint("🌐 [PhoneNumberController] POST → ${AppUrls.userCreated}");
      final checkUserResponse = await http.post(
        Uri.parse(AppUrls.userCreated),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'mobile': fullPhone}),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Check user request timed out');
      });

      debugPrint('📥 [PhoneNumberController] CheckUser Status: ${checkUserResponse.statusCode}');
      debugPrint('📦 [PhoneNumberController] CheckUser Body: ${checkUserResponse.body}');

      if (checkUserResponse.statusCode == 200) {
        final createUserModel = CreateUserModel.fromJson(jsonDecode(checkUserResponse.body));

        if (createUserModel.success == true) {
          debugPrint(
              "✅ [PhoneNumberController] CheckUser Success → Customer ID: ${createUserModel.customerId}, Token: ${createUserModel.token}");
          // Store in DatabaseHelper
          await _dbHelper.createUser(phoneNumberController.text, createUserModel.customerId ?? 0,
              createUserModel.token);

          /// STEP 2: Send OTP
          await Future.delayed(const Duration(milliseconds: 500));
          debugPrint("📡 [PhoneNumberController] Sending OTP to $fullPhone");

          final otpResponse = await http.post(
            Uri.parse(AppUrls.sendOtp),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'mobile': fullPhone,
              'country_code': '+92',
              'message_type': 'sms',
            }),
          ).timeout(const Duration(seconds: 10), onTimeout: () {
            throw Exception('OTP request timed out');
          });

          debugPrint('📥 [PhoneNumberController] SendOTP Status: ${otpResponse.statusCode}');
          debugPrint('📦 [PhoneNumberController] SendOTP Body: ${otpResponse.body}');

          if (otpResponse.statusCode == 200) {
            final sendOtpModel = SendOtpModel.fromJson(jsonDecode(otpResponse.body));

            debugPrint("✅ [PhoneNumberController] OTP: ${sendOtpModel.oTP}");
            debugPrint("📊 [PhoneNumberController] SMS Data: ${sendOtpModel.smsData}");

            if (sendOtpModel.success == true) {
              bool smsStatus = false;

              if (sendOtpModel.smsData != null && sendOtpModel.smsData is Map<String, dynamic>) {
                final smsDataMap = sendOtpModel.smsData as Map<String, dynamic>;
                smsStatus = smsDataMap['success'] == true;
              }

              Get.snackbar(
                'Success',
                smsStatus
                    ? 'OTP sent successfully to $fullPhone'
                    : 'OTP generated but SMS may not be delivered. Use visible OTP for testing.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 4),
              );

              debugPrint("📲 [PhoneNumberController] Navigating to OtpScreen with phone: ${phoneNumberController.text}");
              Get.to(() => OtpScreen(
                phoneNumber: phoneNumberController.text,
                customerId: createUserModel.customerId ?? 0,
                actualOtp: sendOtpModel.oTP,
                token: createUserModel.token,
              ));
            } else {
              debugPrint("❌ [PhoneNumberController] SendOTP Failed → ${sendOtpModel.message}");
              Get.snackbar(
                'Error',
                sendOtpModel.message ?? 'Failed to send OTP',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          } else {
            debugPrint("❌ [PhoneNumberController] SendOTP API error: ${otpResponse.statusCode}");
            _handleApiError(otpResponse);
          }
        } else {
          debugPrint("❌ [PhoneNumberController] CheckUser Failed → ${createUserModel.message}");
          Get.snackbar(
            'Error',
            createUserModel.message ?? 'Failed to check user',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        debugPrint("❌ [PhoneNumberController] CheckUser API error: ${checkUserResponse.statusCode}");
        _handleApiError(checkUserResponse);
      }
    } catch (e) {
      debugPrint("💥 [PhoneNumberController] Exception: $e");
      Get.snackbar(
        'Error',
        'Network error: Please check your internet connection or try again later',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint("🏁 [PhoneNumberController] Phone verification flow completed");
    }
  }

  void _handleApiError(http.Response response) {
    debugPrint("🛑 [PhoneNumberController] Error Status: ${response.statusCode}, Body: ${response.body}");

    String errorMessage = 'Server error occurred';
    try {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? errorMessage;
    } catch (e) {
      debugPrint("❓ [PhoneNumberController] JSON parse failed: $e");
    }

    Get.snackbar(
      'Error',
      '$errorMessage (Code: ${response.statusCode})',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}