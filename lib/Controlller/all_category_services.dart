import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
    debugPrint('HomeServicesController: onInit called');
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    debugPrint('HomeServicesController: Starting fetchCategories');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final customerId = await SharedPreferencesHelper.getUserId();
      debugPrint('HomeServicesController: Retrieved token=$token, customerId=$customerId');

      if (token == null || customerId == null) {
        debugPrint('HomeServicesController: Authentication data missing');
        errorMessage.value = 'User not authenticated. Please log in again.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final url = Uri.parse(AppUrls.allCategoryServices);
      debugPrint('HomeServicesController: Sending GET to $url');

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

      debugPrint('HomeServicesController: Response status=${response.statusCode}, body=${response.body}');

      if (response.statusCode == 200) {
        final allCategoryServices = AllCategoryServices.fromJson(jsonDecode(response.body));
        debugPrint('HomeServicesController: Parsed response success=${allCategoryServices.success}');

        if (allCategoryServices.success == true && allCategoryServices.data != null) {
          if (allCategoryServices.data!.category != null) {
            categories.add(allCategoryServices.data!.category!);
            debugPrint(
                'HomeServicesController: Added category=${allCategoryServices.data!.category!.toJson()}');
          }
          if (allCategoryServices.data!.services != null) {
            services.addAll(allCategoryServices.data!.services!);
            debugPrint(
                'HomeServicesController: Added services=${allCategoryServices.data!.services!.map((s) => s.toJson())}');
          }
          debugPrint('HomeServicesController: Total services=${allCategoryServices.data!.totalServices}');
        } else {
          debugPrint('HomeServicesController: No data or success=false');
          errorMessage.value = 'No categories found';
          Get.snackbar(
            'Error',
            errorMessage.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
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
          debugPrint('HomeServicesController: Error parsing response: $e');
        }
        debugPrint('HomeServicesController: Server error: $error');
        errorMessage.value = error;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('HomeServicesController: Error fetching categories: $e');
      debugPrint('HomeServicesController: Stack trace: $stackTrace');
      errorMessage.value = 'Failed to fetch categories: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint('HomeServicesController: isLoading set to false');
    }
  }

  // Map category names to icons
  IconData getCategoryIcon(String categoryName) {
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
      'Plumber': Icons.plumbing,
    };
    return iconMap[categoryName] ?? Icons.build;
  }
}