import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/all_category_services.dart';
import '../SharedPreference/shared_preference.dart';
import '../constants/app_urls.dart';

class AllHomeServicesCategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <Category>[].obs;
  var services = <Services>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('AllHomeServicesCategoryController: onInit called');
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    debugPrint('AllHomeServicesCategoryController: Starting fetchCategories');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Get token and customerId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final customerId = await SharedPreferencesHelper.getUserId();
      debugPrint('AllHomeServicesCategoryController: Retrieved token=$token, customerId=$customerId');

      if (token == null || customerId == null) {
        debugPrint('AllHomeServicesCategoryController: Authentication data missing');
        errorMessage.value = 'User not authenticated. Please log in again.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed('/enter_phone_number');
        return;
      }

      final url = Uri.parse(AppUrls.allCategoryServices);
      debugPrint('AllHomeServicesCategoryController: Sending GET to $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Fetch categories request timed out');
      });

      debugPrint('AllHomeServicesCategoryController: Response status=${response.statusCode}, body=${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        debugPrint('AllHomeServicesCategoryController: Parsed JSON response=$jsonResponse');

        final allCategoryServices = AllCategoryServices.fromJson(jsonResponse);
        debugPrint('AllHomeServicesCategoryController: Parsed success=${allCategoryServices.success}, data=${allCategoryServices.data?.toJson()}');

        if (allCategoryServices.success == true && allCategoryServices.data != null) {
          if (allCategoryServices.data!.categories != null && allCategoryServices.data!.categories!.isNotEmpty) {
            categories.assignAll(allCategoryServices.data!.categories!);
            debugPrint(
                'AllHomeServicesCategoryController: Added ${allCategoryServices.data!.categories!.length} categories: ${categories.map((c) => c.toJson())}');
          } else {
            debugPrint('AllHomeServicesCategoryController: No categories found in response');
            // Only set error if no services are available either
            if (allCategoryServices.data!.services == null || allCategoryServices.data!.services!.isEmpty) {
              errorMessage.value = 'No categories or services available';
            }
          }
          if (allCategoryServices.data!.services != null && allCategoryServices.data!.services!.isNotEmpty) {
            services.assignAll(allCategoryServices.data!.services!);
            debugPrint(
                'AllHomeServicesCategoryController: Added ${allCategoryServices.data!.services!.length} services: ${services.map((s) => s.toJson())}');
          } else {
            debugPrint('AllHomeServicesCategoryController: No services found in response');
            if (allCategoryServices.data!.categories == null || allCategoryServices.data!.categories!.isEmpty) {
              errorMessage.value = 'No categories or services available';
            }
          }
          debugPrint('AllHomeServicesCategoryController: Total services=${allCategoryServices.data!.totalServices}');
        } else {
          debugPrint('AllHomeServicesCategoryController: Success=false or no data');
          errorMessage.value = jsonResponse['message'] ?? 'No categories or services found';
          Get.snackbar(
            'Error',
            errorMessage.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        String error = 'Server error: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          error = errorData['message'] ?? error;
          if (errorData['errors'] != null && errorData['errors'] is Map) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            error = errors.values.expand((e) => e as List).join(', ');
          }
        } catch (e) {
          debugPrint('AllHomeServicesCategoryController: Error parsing error response: $e');
        }
        debugPrint('AllHomeServicesCategoryController: Server error: $error');
        errorMessage.value = error;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('AllHomeServicesCategoryController: Error fetching categories: $e');
      debugPrint('AllHomeServicesCategoryController: Stack trace: $stackTrace');
      errorMessage.value = 'Failed to fetch categories: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      debugPrint('AllHomeServicesCategoryController: isLoading set to false');
    }
  }

  // Map category names to icons
  IconData getCategoryIcon(String? categoryName) {
    final iconMap = {
      'AC Services': Icons.ac_unit,
      'Carpenter': Icons.handyman,
      'Electrician': Icons.electrical_services,
      'Geyser': Icons.water,
      'Handyman': Icons.build,
      'Home Appliances': Icons.kitchen,
      'Home Inspection': Icons.search,
      'Painter': Icons.format_paint,
      'Pest Control': Icons.bug_report,
      'Plumbing': Icons.plumbing,
    };
    return iconMap[categoryName] ?? Icons.build;
  }
}
