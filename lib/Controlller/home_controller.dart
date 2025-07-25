import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/constants/app_urls.dart';
import '../models/home_model.dart'; // Correct the path as per your folder structure

class HomeController extends GetxController {
  var isLoading = false.obs;
  var homeModel = HomeModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  void fetchHomeData() async {
    isLoading(true);
    try {
      debugPrint("📡 Fetching home data...");
      final response = await http.get(
        Uri.parse(AppUrls.getHome),
        headers: {
          'Accept': 'application/json',
        },
      );

      debugPrint("📥 Response status: ${response.statusCode}");
      debugPrint("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        homeModel.value = HomeModel.fromJson(jsonData);
        debugPrint("✅ Home data parsed successfully");
      } else {
        debugPrint("❌ Failed to fetch home data");
      }
    } catch (e) {
      debugPrint("💥 Exception occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}
