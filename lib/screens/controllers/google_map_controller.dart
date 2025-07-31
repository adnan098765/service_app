import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  var currentLocation = Rxn<LatLng>();
  var isLoading = true.obs;
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnabled) {
      _showLocationDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLocation.value = LatLng(position.latitude, position.longitude);
      isLoading.value = false;

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation.value!));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get location: $e");
    }
  }

  void _showLocationDialog() {
    Get.defaultDialog(
      title: "Enable Location",
      middleText: "Location services are disabled. Please enable them to continue.",
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          await Geolocator.openLocationSettings();
          _getCurrentLocation();
        },
        child: const Text("Enable"),
      ),
    );
  }

  void _showPermissionDialog() {
    Get.defaultDialog(
      title: "Location Permission",
      middleText: "This app needs location permission to work properly.",
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Geolocator.openAppSettings();
        },
        child: const Text("Open Settings"),
      ),
    );
  }
}
