
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/add_address_model.dart';
import '../SharedPreference/shared_preference.dart';
import '../constants/app_urls.dart';


class AddAddressController extends GetxController {
  var isLoading = false.obs;
  var currentAddress = "".obs;
  var savedAddresses = <Addresses>[].obs;
  var customer = Rxn<Customer>();

  Future<bool> addAddress({
    required String addressType,
    required String address,
    required double latitude,
    required double longitude,
    bool isDefault = true,
    int? customerId,
    String? token,
  }) async {
    debugPrint(
        'AddAddressController: Starting addAddress with addressType=$addressType, address=$address, latitude=$latitude, longitude=$longitude, isDefault=$isDefault, customerId=$customerId');

    try {
      isLoading.value = true;
      debugPrint('AddAddressController: isLoading set to true');

      final prefs = await SharedPreferences.getInstance();
      String? storedToken = token ?? prefs.getString('auth_token');
      int? storedCustomerId = customerId ?? await SharedPreferencesHelper.getUserId();

      debugPrint('AddAddressController: Retrieved token=$storedToken, storedCustomerId=$storedCustomerId');

      if (storedCustomerId == null || storedToken == null) {
        debugPrint('AddAddressController: Authentication data missing');
        Get.snackbar(
          'Error',
          'Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final requestBody = jsonEncode({
        'customer_id': storedCustomerId,
        'address_type': addressType,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'is_default': isDefault,
      });
      final url = AppUrls.addAddress;
      debugPrint('AddAddressController: Sending POST to $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      debugPrint('AddAddressController: Response status=${response.statusCode}, body=${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final addAddressResponse = AddAddress.fromJson(responseData);

        if (addAddressResponse.success == true) {
          debugPrint('AddAddressController: Address added successfully');
          currentAddress.value = address;
          if (addAddressResponse.customer != null) {
            customer.value = addAddressResponse.customer;
            savedAddresses.value = addAddressResponse.customer!.addresses ?? [];
            await SharedPreferencesHelper.setUserProfile(addAddressResponse.customer!.toJson());
            if (addAddressResponse.customer!.id != null) {
              await SharedPreferencesHelper.setUserId(addAddressResponse.customer!.id!);
            }
          }
          Get.snackbar(
            'Success',
            addAddressResponse.message ?? 'Address added successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        } else {
          debugPrint('AddAddressController: Failed to add address');
          Get.snackbar(
            'Error',
            addAddressResponse.message ?? 'Failed to add address',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        String errorMessage = 'Server error: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          debugPrint('AddAddressController: Error parsing response: $e');
        }
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      debugPrint('AddAddressController: Error: $e');
      Get.snackbar(
        'Error',
        e.toString().contains('timeout') ? 'Request timed out. Check your connection.' : 'Failed to add address: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
      debugPrint('AddAddressController: isLoading set to false');
    }
  }

  Future<void> loadSavedAddresses() async {
    debugPrint('AddAddressController: Starting loadSavedAddresses');
    try {
      final userProfile = await SharedPreferencesHelper.getUserProfile();
      if (userProfile != null) {
        final customerData = Customer.fromJson(userProfile);
        customer.value = customerData;
        savedAddresses.value = customerData.addresses ?? [];
        final defaultAddress = savedAddresses.firstWhereOrNull((address) => address.isDefault == true);
        if (defaultAddress != null) {
          currentAddress.value = defaultAddress.address ?? "";
        }
      }
    } catch (e) {
      debugPrint('AddAddressController: Error loading addresses: $e');
    }
  }

  void updateCurrentAddress(String address) {
    currentAddress.value = address;
    debugPrint('AddAddressController: Updated currentAddress to $address');
  }

  List<Map<String, String>> getAddressesForUI() {
    final addresses = savedAddresses.map((address) => {
      'id': address.id?.toString() ?? '',
      'address': address.address ?? '',
      'type': address.addressType ?? 'home',
    }).toList();
    debugPrint('AddAddressController: Generated addresses for UI: $addresses');
    return addresses;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('AddAddressController: Initialized');
    loadSavedAddresses();
  }
}