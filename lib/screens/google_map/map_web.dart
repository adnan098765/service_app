import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text.dart';
import '../Controlller/add_address_controller.dart';
import '../bottom_nav_bar/bottom_nav_screen.dart';

class LocationConfirmationScreen extends StatelessWidget {
  final LatLng selectedLocation;
  final String? address;
  final String? city;
  final bool isManualLocation;
  final int customerId;
  final String? token;

  const LocationConfirmationScreen({
    super.key,
    required this.selectedLocation,
    this.address,
    this.city,
    required this.isManualLocation,
    required this.customerId,
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    final AddAddressController addAddressController = Get.find<AddAddressController>();
    print('LocationConfirmationScreen: AddAddressController instance: ${addAddressController.runtimeType}, hashCode: ${addAddressController.hashCode} @ ${DateTime.now().toIso8601String()}');

    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: 'Delivering service at:',
              fontSize: 20.px,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlueShade,
            ),
            SizedBox(height: 20.px),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.px),
              width: double.infinity,
              child: Center(
                child: CustomText(text: address ?? 'Selected Location', fontSize: 18.px, fontWeight: FontWeight.w500),
              ),
            ),
            if (city != null) ...[
              SizedBox(height: 10.px),
              CustomText(text: city!, fontSize: 16.px, color: Colors.grey.shade600),
            ],
            SizedBox(height: 30.px),
            Obx(
                  () => addAddressController.isLoading.value
                  ? CircularProgressIndicator(color: AppColors.darkBlueShade)
                  : InkWell(
                onTap: () async {
                  if (token == null) {
                    Get.snackbar('Error', 'Authentication token missing');
                    print('[LOG] LocationConfirmationScreen: token is null');
                    return;
                  }
                  print('[LOG] Calling addAddress with customerId=$customerId, token=$token');
                  bool success = await addAddressController.addAddress(
                    addressType: 'home',
                    address: address ?? 'Unknown Address',
                    latitude: selectedLocation.latitude,
                    longitude: selectedLocation.longitude,
                    isDefault: true,
                    customerId: customerId,
                  );
                  if (success) {
                    Get.offAll(
                      BottomNavScreen(
                        latitude: selectedLocation.latitude,
                        longitude: selectedLocation.longitude,
                        address: address,
                        city: city,
                        isManualLocation: isManualLocation,
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 200.px,
                  padding: EdgeInsets.symmetric(vertical: 16.px),
                  decoration: BoxDecoration(
                    color: AppColors.darkBlueShade,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Confirm Address',
                      style: TextStyle(color: Colors.white, fontSize: 16.px, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}