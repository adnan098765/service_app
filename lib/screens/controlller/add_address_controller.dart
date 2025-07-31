import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_urls.dart';
import '../../shared_prefs/shared_preference.dart';
import '../Models/add_address_model.dart';

class AddAddressController extends GetxController {
  var isLoading = false.obs;
  var currentAddress = "".obs;
  var savedAddresses = <Addresses>[].obs;
  var customer = Rxn<Customer>();

  @override
  void onInit() {
    super.onInit();
    print('AddAddressController: Initialized, hashCode: ${this.hashCode} @ ${DateTime.now().toIso8601String()}');
    loadSavedAddresses();
  }

  Future<bool> addAddress({
    required String addressType,
    required String address,
    required double latitude,
    required double longitude,
    bool isDefault = true,
    int? customerId,
    String? token,
  }) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? storedToken = token ?? prefs.getString('auth_token');
      int? storedCustomerId = customerId ?? await SharedPrefServices.getUserId();

      if (storedCustomerId == null || storedToken == null) {
        Get.snackbar('Error', 'Please log in again.', backgroundColor: Colors.red, colorText: Colors.white);
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

      final response = await http
          .post(
        Uri.parse(AppUrls.addAddress),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
        body: requestBody,
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timed out'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final addAddressResponse = AddAddress.fromJson(responseData);

        if (addAddressResponse.success == true) {
          currentAddress.value = address;
          if (addAddressResponse.customer != null) {
            customer.value = addAddressResponse.customer;
            savedAddresses.value = addAddressResponse.customer!.addresses ?? [];
            await SharedPrefServices.saveUserProfile(addAddressResponse.customer!.toJson());
            if (addAddressResponse.customer!.id != null) {
              await SharedPrefServices.saveUserId(addAddressResponse.customer!.id!);
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
          debugPrint('Error parsing response: $e');
        }
        Get.snackbar('Error', errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().contains('timeout') ? 'Request timed out. Check your connection.' : 'Failed to add address: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSavedAddresses() async {
    try {
      final userProfile = await SharedPrefServices.getUserProfile();
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
      debugPrint('Error loading addresses: $e');
    }
  }

  void updateCurrentAddress(String address) {
    currentAddress.value = address;
  }

  List<Map<String, String>> getAddressesForUI() {
    return savedAddresses
        .map(
          (address) => {
        'id': address.id?.toString() ?? '',
        'address': address.address ?? '',
        'type': address.addressType ?? 'home',
      },
    )
        .toList();
  }
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../constants/app_urls.dart';
// import '../../shared_prefs/shared_preference.dart';
// import '../Models/add_address_model.dart';
//
// class AddAddressController extends GetxController {
//   var isLoading = false.obs;
//   var currentAddress = "".obs;
//   var savedAddresses = <Addresses>[].obs;
//   var customer = Rxn<Customer>();
//
//   Future<bool> addAddress({
//     required String addressType,
//     required String address,
//     required double latitude,
//     required double longitude,
//     bool isDefault = true,
//     int? customerId,
//     String? token,
//   }) async {
//     try {
//       isLoading.value = true;
//       final prefs = await SharedPreferences.getInstance();
//       String? storedToken = token ?? prefs.getString('auth_token');
//       int? storedCustomerId = customerId ?? await SharedPrefServices.getUserId();
//
//       if (storedCustomerId == null || storedToken == null) {
//         Get.snackbar('Error', 'Please log in again.', backgroundColor: Colors.red, colorText: Colors.white);
//         return false;
//       }
//
//       final requestBody = jsonEncode({
//         'customer_id': storedCustomerId,
//         'address_type': addressType,
//         'address': address,
//         'latitude': latitude,
//         'longitude': longitude,
//         'is_default': isDefault,
//       });
//
//       final response = await http
//           .post(
//         Uri.parse(AppUrls.addAddress),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $storedToken',
//         },
//         body: requestBody,
//       )
//           .timeout(
//         const Duration(seconds: 10),
//         onTimeout: () => throw Exception('Request timed out'),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         final addAddressResponse = AddAddress.fromJson(responseData);
//
//         if (addAddressResponse.success) {
//           currentAddress.value = address;
//           if (addAddressResponse.customer != null) {
//             customer.value = addAddressResponse.customer;
//             savedAddresses.value = addAddressResponse.customer!.addresses ?? [];
//             await SharedPrefServices.saveUserProfile(addAddressResponse.customer!.toJson());
//             if (addAddressResponse.customer!.id != null) {
//               await SharedPrefServices.saveUserId(addAddressResponse.customer!.id!);
//             }
//           }
//           if (addAddressResponse.address != null) {
//             savedAddresses.add(Addresses(
//               id: addAddressResponse.address!.id,
//               customerId: addAddressResponse.address!.customerId?.toString(),
//               addressType: addAddressResponse.address!.addressType,
//               address: addAddressResponse.address!.address,
//               latitude: addAddressResponse.address!.latitude,
//               longitude: addAddressResponse.address!.longitude,
//               isDefault: addAddressResponse.address!.isDefault,
//               createdAt: addAddressResponse.address!.createdAt,
//               updatedAt: addAddressResponse.address!.updatedAt,
//             ));
//           }
//           Get.snackbar(
//             'Success',
//             addAddressResponse.message ?? 'Address added successfully',
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//           return true;
//         } else {
//           Get.snackbar(
//             'Error',
//             addAddressResponse.message ?? 'Failed to add address',
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//           return false;
//         }
//       } else {
//         String errorMessage = 'Server error: ${response.statusCode}';
//         try {
//           final errorData = jsonDecode(response.body);
//           errorMessage = errorData['message'] ?? errorMessage;
//         } catch (e) {
//           debugPrint('Error parsing response: $e');
//         }
//         Get.snackbar('Error', errorMessage, backgroundColor: Colors.red, colorText: Colors.white);
//         return false;
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         e.toString().contains('timeout') ? 'Request timed out. Check your connection.' : 'Failed to add address: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> loadSavedAddresses() async {
//     try {
//       final userProfile = await SharedPrefServices.getUserProfile();
//       if (userProfile != null) {
//         final customerData = Customer.fromJson(userProfile);
//         customer.value = customerData;
//         savedAddresses.value = customerData.addresses ?? [];
//         final defaultAddress = savedAddresses.firstWhereOrNull((address) => address.isDefault == true);
//         if (defaultAddress != null) {
//           currentAddress.value = defaultAddress.address ?? "";
//         }
//       }
//     } catch (e) {
//       debugPrint('Error loading addresses: $e');
//     }
//   }
//
//   void updateCurrentAddress(String address) {
//     currentAddress.value = address;
//   }
//
//   List<Map<String, String>> getAddressesForUI() {
//     return savedAddresses
//         .map(
//           (address) => {
//         'id': address.id?.toString() ?? '',
//         'address': address.address ?? '',
//         'type': address.addressType ?? 'home',
//       },
//     )
//         .toList();
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     print('AddAddressController type: ${this.runtimeType}');
//     loadSavedAddresses();
//   }
// }