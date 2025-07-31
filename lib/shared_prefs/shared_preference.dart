import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  // Keys
  static const String _keyUserId = 'userId';
  static const String _keyUserProfile = 'userProfile';
  static const String _keyAuthToken = 'auth_token';

  // Save User ID
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    log('[SharedPref] Saved userId: $userId');
  }

  // Get User ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_keyUserId);
    log('ℹ️ [SharedPref] Fetched userId: $userId');
    return userId;
  }

  // Remove User ID
  static Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    log('🗑️ [SharedPref] Removed userId');
  }

  // Save User Profile
  static Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonProfile = jsonEncode(profile);
    await prefs.setString(_keyUserProfile, jsonProfile);
    log('[SharedPref] Saved userProfile: $jsonProfile');
  }

  // Get User Profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString(_keyUserProfile);
    log('[SharedPref] Fetched userProfile: $profileString');
    return profileString != null ? jsonDecode(profileString) : null;
  }

  // Remove User Profile
  static Future<void> removeUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserProfile);
    log('[SharedPref] Removed userProfile');
  }

  // Save Auth Token
  static Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
    log('Token saved in Shared Prefs: $token');
  }

  // Get Auth Token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyAuthToken);
    log('[SharedPref] Fetched auth_token: $token');
    return token;
  }

  // Remove Auth Token
  static Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken);
    log('[SharedPref] Removed auth_token');
  }

  // Clear All User Data
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserProfile);
    await prefs.remove(_keyAuthToken);
    log(' [SharedPref] Cleared all user-related data');
  }
}
