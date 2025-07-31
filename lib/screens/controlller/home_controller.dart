import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_urls.dart';
import '../../shared_prefs/shared_preference.dart';
import '../models/home_model.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var homeModel = HomeModel().obs;
  final customerId =  SharedPrefServices.getUserId();

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  void fetchHomeData() async {
    isLoading(true);
    try {
      debugPrint("📡 [HomeController] Fetching home data...");

      // Get auth token from SharedPreferences
      final token = await SharedPrefServices.getAuthToken();

      if (token == null || token.isEmpty) {
        debugPrint("❗ [HomeController] No auth token found!");
        isLoading(false);
        return;
      }

      debugPrint("🔐 [HomeController] Using token: $token");

      final response = await http.get(
        Uri.parse(AppUrls.getHome),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      debugPrint("📥 [HomeController] Response status: ${response.statusCode}");
      debugPrint("📥 [HomeController] Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        homeModel.value = HomeModel.fromJson(jsonData);
        debugPrint("✅ [HomeController] Home data parsed successfully");
      } else {
        debugPrint("❌ [HomeController] Failed to fetch home data");
      }
    } catch (e) {
      debugPrint("💥 [HomeController] Exception: $e");
    } finally {
      isLoading(false);
    }
  }
}
