import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AppColors/app_colors.dart';
import '../Controlller/add_address_controller.dart';
import '../SharedPreference/shared_preference.dart';
import '../widgets/custom_text.dart';


class AddAddressScreen extends StatelessWidget {
  AddAddressScreen({super.key});

  final TextEditingController addressController = TextEditingController();
  final Completer<GoogleMapController> _mapController = Completer();
  final RxDouble latitude = 24.8607.obs;
  final RxDouble longitude = 67.0011.obs;

  @override
  Widget build(BuildContext context) {
    final AddAddressController controller = Get.find<AddAddressController>();

    // Set initial address if available
    if (controller.currentAddress.value.isNotEmpty) {
      addressController.text = controller.currentAddress.value;
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Add New Address',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: AppColors.darkBlueShade,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Adaptive.h(50),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude.value, longitude.value),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController mapController) {
                  _mapController.complete(mapController);
                },
                onTap: (LatLng latLng) {
                  latitude.value = latLng.latitude;
                  longitude.value = latLng.longitude;
                  addressController.text = 'Selected Location'; // Replace with geocoded address in production
                  controller.updateCurrentAddress(addressController.text);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Adaptive.w(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Enter Address Details',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: Adaptive.h(2)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.appColor,
                            width: 1.5,
                          ),
                        ),
                        hintText: "Enter full address",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Adaptive.h(2),
                          horizontal: Adaptive.w(4),
                        ),
                      ),
                      onChanged: (value) {
                        controller.updateCurrentAddress(value);
                      },
                    ),
                  ),
                  SizedBox(height: Adaptive.h(2)),
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                      if (addressController.text.isNotEmpty) {
                        final customerId = await SharedPreferencesHelper.getUserId();
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('auth_token');
                        final success = await controller.addAddress(
                          addressType: 'home',
                          address: addressController.text,
                          latitude: latitude.value,
                          longitude: longitude.value,
                          isDefault: true,
                          customerId: customerId,
                          token: token,
                        );
                        if (success) {
                          Get.back();
                        }
                      } else {
                        Get.snackbar('Error', 'Please enter an address');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      minimumSize: Size(double.infinity, Adaptive.h(6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: CustomText(
                      text: controller.isLoading.value ? 'Adding...' : 'Add Address',
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  )),
                  SizedBox(height: Adaptive.h(3)),
                  CustomText(
                    text: 'Saved Addresses',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: Adaptive.h(1)),
                  Obx(() => controller.savedAddresses.isEmpty
                      ? CustomText(
                    text: 'No saved addresses',
                    fontSize: 14.sp,
                    color: Colors.grey,
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.savedAddresses.length,
                    itemBuilder: (context, index) {
                      final address = controller.savedAddresses[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: Adaptive.h(1)),
                        child: ListTile(
                          title: CustomText(
                            text: address.address ?? 'No Address',
                            fontSize: 14.sp,
                          ),
                          subtitle: CustomText(
                            text: address.addressType ?? 'home',
                            fontSize: 12.sp,
                          ),
                          trailing: address.isDefault == true
                              ? Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            controller.updateCurrentAddress(address.address ?? '');
                            Get.back();
                          },
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}