import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_urls.dart';
import '../Models/get_categories_with_featured.dart';

class CategoriesWithFeaturedController extends GetxController {
  var isLoading = false.obs;
  var model = GetCategoriesWithFeaturedModel().obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('CategoriesWithFeaturedController: onInit called');
    fetchCategoriesWithFeatured();
  }

  Future<void> fetchCategoriesWithFeatured() async {
    debugPrint('CategoriesWithFeaturedController: Starting fetchCategoriesWithFeatured');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final url = Uri.parse(AppUrls.getCategoriesWithFeatured); // Ensure this URL is defined in AppUrls
      debugPrint('CategoriesWithFeaturedController: Sending GET to $url');

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json', 'Accept': 'application/json'})
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out');
            },
          );

      debugPrint('CategoriesWithFeaturedController: Response status=${response.statusCode}, body=${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        model.value = GetCategoriesWithFeaturedModel.fromJson(jsonData);
        debugPrint('CategoriesWithFeaturedController: Parsed response success=${model.value.success}');
        debugPrint('CategoriesWithFeaturedController: Categories count=${model.value.data?.categories?.length ?? 0}');
        debugPrint(
          'CategoriesWithFeaturedController: Featured services count=${model.value.data?.featuredServices?.length ?? 0}',
        );
      } else {
        String error = 'Server error: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          error = errorData['message'] ?? error;
        } catch (e) {
          debugPrint('CategoriesWithFeaturedController: Error parsing response: $e');
        }
        debugPrint('CategoriesWithFeaturedController: Server error: $error');
        errorMessage.value = error;
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e, stackTrace) {
      debugPrint('CategoriesWithFeaturedController: Error fetching data: $e');
      debugPrint('CategoriesWithFeaturedController: Stack trace: $stackTrace');
      errorMessage.value = 'Failed to fetch data: $e';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      debugPrint('CategoriesWithFeaturedController: isLoading set to false');
    }
  }
}
