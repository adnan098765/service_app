import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> setUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    debugPrint('[SharedPreferencesHelper] Set userId: $userId');
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    debugPrint('[SharedPreferencesHelper] Get userId: $userId');
    return userId;
  }

  static Future<void> setUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', jsonEncode(profile));
    debugPrint('[SharedPreferencesHelper] Set userProfile: $profile');
  }

  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString('userProfile');
    debugPrint('[SharedPreferencesHelper] Get userProfile: $profileString');
    return profileString != null ? jsonDecode(profileString) : null;
  }

  static Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint('[SharedPreferencesHelper] Set auth_token: $token');
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    debugPrint('[SharedPreferencesHelper] Get auth_token: $token');
    return token;
  }

  static Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    debugPrint('[SharedPreferencesHelper] Removed auth_token');
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userProfile');
    await prefs.remove('auth_token');
    debugPrint('[SharedPreferencesHelper] Cleared user data');
  }
}
