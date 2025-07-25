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
    int? customerId, // Optional customerId parameter
    String? token, // Optional token parameter
  }) async {
    debugPrint(
        'AddAddressController: Starting addAddress with addressType=$addressType, address=$address, latitude=$latitude, longitude=$longitude, isDefault=$isDefault, customerId=$customerId');

    try {
      isLoading.value = true;
      debugPrint('AddAddressController: isLoading set to true');

      // Get user token and customer ID from SharedPreferences if not provided
      final prefs = await SharedPreferences.getInstance();
      String? storedToken = token ?? prefs.getString('auth_token');
      int? storedCustomerId = customerId ?? await SharedPreferencesHelper.getUserId();

      debugPrint('AddAddressController: Retrieved token=$storedToken, storedCustomerId=$storedCustomerId');

      if (storedCustomerId == null || storedToken == null) {
        debugPrint('AddAddressController: Authentication data missing (customerId=$storedCustomerId, token=$storedToken)');
        Get.snackbar(
          'Error',
          'User authentication data missing. Please log in again.',
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
      debugPrint('AddAddressController: Sending POST to ${AppUrls.addAddress} with body=$requestBody');

      final response = await http.post(
        Uri.parse(AppUrls.addAddress),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Add address request timed out');
      });

      debugPrint('AddAddressController: Add Address Response status=${response.statusCode}, body=${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final addAddressResponse = AddAddress.fromJson(responseData);

        if (addAddressResponse.success == true) {
          debugPrint('AddAddressController: Address added successfully, message=${addAddressResponse.message}');

          // Update current address
          currentAddress.value = address;
          debugPrint('AddAddressController: Updated currentAddress to $address');

          // Update customer data
          if (addAddressResponse.customer != null) {
            customer.value = addAddressResponse.customer;
            savedAddresses.value = addAddressResponse.customer!.addresses ?? [];
            debugPrint(
                'AddAddressController: Updated customer=${customer.value?.toJson()}, savedAddresses=${savedAddresses.map((a) => a.toJson())}');

            // Save user profile to SharedPreferences
            await SharedPreferencesHelper.setUserProfile(addAddressResponse.customer!.toJson());
            debugPrint('AddAddressController: Saved user profile to SharedPreferences');

            // Save user ID
            if (addAddressResponse.customer!.id != null) {
              await SharedPreferencesHelper.setUserId(addAddressResponse.customer!.id!);
              debugPrint('AddAddressController: Saved userId=${addAddressResponse.customer!.id} to SharedPreferences');
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
          debugPrint('AddAddressController: Failed to add address, message=${addAddressResponse.message}');
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
          if (errorData['errors'] != null && errorData['errors'] is Map) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            errorMessage = errors.values.expand((e) => e as List).join(', ');
          }
        } catch (e) {
          debugPrint('AddAddressController: Error parsing response: $e');
        }
        debugPrint('AddAddressController: Server error, statusCode=${response.statusCode}, message=$errorMessage');
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('AddAddressController: Error adding address: $e');
      debugPrint('AddAddressController: Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Failed to add address: $e',
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
      debugPrint('AddAddressController: Retrieved userProfile=$userProfile');

      if (userProfile != null) {
        final customerData = Customer.fromJson(userProfile);
        customer.value = customerData;
        savedAddresses.value = customerData.addresses ?? [];
        debugPrint(
            'AddAddressController: Loaded customer=${customerData.toJson()}, savedAddresses=${savedAddresses.map((a) => a.toJson())}');

        final defaultAddress = savedAddresses.firstWhereOrNull((address) => address.isDefault == true);
        if (defaultAddress != null) {
          currentAddress.value = defaultAddress.address ?? "";
          debugPrint('AddAddressController: Set currentAddress to ${currentAddress.value}');
        } else {
          debugPrint('AddAddressController: No default address found');
        }
      } else {
        debugPrint('AddAddressController: No user profile found in SharedPreferences');
      }
    } catch (e, stackTrace) {
      debugPrint('AddAddressController: Error loading saved addresses: $e');
      debugPrint('AddAddressController: Stack trace: $stackTrace');
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
    debugPrint('AddAddressController: onInit called');
    loadSavedAddresses();
  }
}