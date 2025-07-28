
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../BottomNavBar/bottom_nav_screen.dart';
import '../DatabaseHelper/database_helper.dart';
import '../Models/update_profile_model.dart';
import '../SharedPreference/shared_preference.dart';
import '../constants/app_urls.dart';
import '../google_map/map_screen.dart';


class ProfileController extends GetxController {
  var isLoading = false.obs;
  var isPhoneValid = false.obs;
  var isNameValid = false.obs;
  var isSecondNameValid = false.obs;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> updateProfile({
    required String phoneNumber,
    required String firstName,
    required String secondName,
    required String email,
    required String gender,
    required int customerId,
    required String? token,
  }) async {
    isLoading.value = true;
    debugPrint('🟢 [ProfileController] Starting updateProfile for +92$phoneNumber, customerId: $customerId');

    try {
      if (phoneNumber.length != 10) {
        Get.snackbar('Error', 'Please enter a valid 10-digit phone number');
        return;
      }
      if (firstName.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter your first name');
        return;
      }
      if (secondName.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter your last name');
        return;
      }
      if (email.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter an email address');
        return;
      }

      final fullPhone = '+92$phoneNumber';

      /// ✅ Use helper to store userId, token, profile
      await SharedPreferencesHelper.setUserId(customerId);
      if (token != null) await SharedPreferencesHelper.setAuthToken(token);
      await SharedPreferencesHelper.setUserProfile({
        'first_name': firstName,
        'last_name': secondName,
        'email': email,
        'gender': gender,
      });

      /// ✅ Also store in local DB (optional)
      await _dbHelper.createUser(phoneNumber, customerId, token);
      debugPrint('[ProfileController] Stored locally: ID: $customerId, token: $token');

      final url = AppUrls.updateProfile;
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final body = jsonEncode({
        'customer_id': customerId,
        'first_name': firstName.trim(),
        'last_name': secondName.trim(),
        'email': email,
        'gender': gender.toLowerCase(),
      });

      debugPrint('[ProfileController] POST request to: $url');
      debugPrint('[ProfileController] Headers: $headers');
      debugPrint('[ProfileController] Body: $body');

      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headers,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Update profile request timed out');
      });

      debugPrint('[ProfileController] Update Profile Response: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updateProfile = UpdateProfile.fromJson(data);

        if (updateProfile.token != null) {
          await SharedPreferencesHelper.setAuthToken(updateProfile.token!);
          await _dbHelper.updateUserToken(phoneNumber, updateProfile.token!);
          debugPrint('[ProfileController] Token updated: ${updateProfile.token}');
        }

        if (updateProfile.needsAddress == true) {
          debugPrint('[ProfileController] Navigating to CombinedLocationScreen');
          Get.to(() => CombinedLocationScreen(
            onSelect: (location, address) {
              debugPrint('[ProfileController] Selected Location: $location, Address: $address');
            },
          ), arguments: {
            'phoneNumber': phoneNumber,
            'customerId': customerId,
            'token': updateProfile.token ?? token,
          });
        } else {
          debugPrint('[ProfileController] Navigating to BottomNavScreen');
          Get.offAll(() => BottomNavScreen(
            latitude: 0.0,
            longitude: 0.0,
            address: '',
            city: '',
            isManualLocation: false,
          ));
        }
      } else {
        String errorMessage = 'Failed to update profile';
        try {
          final data = jsonDecode(response.body);
          errorMessage = data['message'] ?? errorMessage;
          if (data['errors'] != null && data['errors'] is Map) {
            final errors = data['errors'] as Map<String, dynamic>;
            errorMessage = errors.values.expand((e) => e as List).join(', ');
          }
        } catch (e) {
          debugPrint('[ProfileController] Error parsing response: $e');
        }
        debugPrint('[ProfileController] Error: $errorMessage');
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      debugPrint('[ProfileController] Exception: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
      debugPrint('[ProfileController] updateProfile completed');
    }
  }

}