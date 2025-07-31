import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_urls.dart';
import '../../shared_prefs/shared_preference.dart';
import '../Models/update_profile_model.dart';
import '../bottom_nav_bar/bottom_nav_screen.dart';
import '../database_helper/database_helper.dart';
import '../google_map/map_screen.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final _dbHelper = DatabaseHelper.instance;

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

    if (phoneNumber.length != 10 || firstName.trim().isEmpty || secondName.trim().isEmpty || email.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields correctly');
      isLoading.value = false;
      return;
    }

    final fullPhone = '+92$phoneNumber';

    // Save user data locally
    await SharedPrefServices.saveUserId(customerId);
    if (token != null) await SharedPrefServices.setAuthToken(token);
    await SharedPrefServices.saveUserProfile({
      'first_name': firstName,
      'last_name': secondName,
      'email': email,
      'gender': gender,
    });

    await _dbHelper.createUser(phoneNumber, customerId, token);

    final response = await http
        .post(
          Uri.parse(AppUrls.updateProfile),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'customer_id': customerId,
            'first_name': firstName.trim(),
            'last_name': secondName.trim(),
            'email': email,
            'gender': gender.toLowerCase(),
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final updateProfile = UpdateProfile.fromJson(data);

      if (updateProfile.token != null) {
        await SharedPrefServices.setAuthToken(updateProfile.token!);
        await _dbHelper.updateUserToken(phoneNumber, updateProfile.token!);
      }

      if (updateProfile.needsAddress == true) {
        Get.to(
          () => CombinedLocationScreen(onSelect: (location, address) {}),
          arguments: {'phoneNumber': phoneNumber, 'customerId': customerId, 'token': updateProfile.token ?? token},
        );
      } else {
        Get.offAll(
          () => BottomNavScreen(latitude: 0.0, longitude: 0.0, address: '', city: '', isManualLocation: false),
        );
      }
    } else {
      String errorMessage = 'Failed to update profile';
      try {
        final data = jsonDecode(response.body);
        errorMessage = data['message'] ?? errorMessage;
        if (data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.expand((e) => e as List).join(', ');
        }
      } catch (_) {}
      Get.snackbar('Error', errorMessage);
    }

    isLoading.value = false;
  }
}
