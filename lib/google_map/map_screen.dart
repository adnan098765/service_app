import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled2/widgets/custom_text.dart';
import '../AppColors/app_colors.dart';
import '../BottomNavBar/bottom_nav_screen.dart';

// New Confirmation Screen
class LocationConfirmationScreen extends StatelessWidget {
  final LatLng selectedLocation;
  final String? address;
  final String? city;
  final bool isManualLocation;

  const LocationConfirmationScreen({
    super.key,
    required this.selectedLocation,
    this.address,
    this.city,
    required this.isManualLocation,
  });

  @override
  Widget build(BuildContext context) {
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
            // Wrap CustomText in a Container to handle text alignment
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.px),
              width: double.infinity,
              child: Center(
                child: CustomText(
                  text: address ?? 'Selected Location',
                  fontSize: 18.px,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (city != null) ...[
              SizedBox(height: 10.px),
              CustomText(
                text: city!,
                fontSize: 16.px,
                color: Colors.grey.shade600,
              ),
            ],
            SizedBox(height: 30.px),
            InkWell(
              onTap: () {
                Get.offAll(BottomNavScreen(
                  latitude: selectedLocation.latitude,
                  longitude: selectedLocation.longitude,
                  address: address,
                  city: city,
                  isManualLocation: isManualLocation,
                ));
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
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.px,
                      fontWeight: FontWeight.bold,
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
class CombinedLocationScreen extends StatefulWidget {
  const CombinedLocationScreen({super.key, required Null Function(dynamic location, dynamic address) onSelect});

  @override
  State<CombinedLocationScreen> createState() => _CombinedLocationScreenState();
}

class _CombinedLocationScreenState extends State<CombinedLocationScreen> {
  final searchController = TextEditingController();
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  final String googleApiKey = "AIzaSyClwNhuYxVRorDGtuXSgH8bU7AaTDeJzH0";
  bool isLoading = true;
  String? address;
  String? city;
  Position? currentPosition;
  bool isManualSelection = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentPosition = position;
        if (!isManualSelection) {
          selectedLocation = LatLng(position.latitude, position.longitude);
        }
        isLoading = false;
      });

      if (!isManualSelection) {
        await _getAddressFromLatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        address = 'Unable to fetch location';
        city = 'Unknown location';
      });
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          address = '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
          city = '${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        address = 'Unable to fetch address';
        city = 'Unknown location';
      });
    }
  }

  void _setSelectedLocation(LatLng newLocation, {bool isManual = false}) {
    setState(() {
      selectedLocation = newLocation;
      isManualSelection = isManual;
    });
    mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
    _getAddressFromLatLng(newLocation.latitude, newLocation.longitude);
  }

  void _navigateToBottomNavScreen() {
    if (selectedLocation != null) {
      Get.to(() => LocationConfirmationScreen(
        selectedLocation: selectedLocation!,
        address: address,
        city: city,
        isManualLocation: isManualSelection,
      ));
    } else {
      Get.snackbar('Error', 'Please select a location first');
    }
  }

  void _handleCurrentLocationTap() async {
    if (currentPosition != null) {
      _setSelectedLocation(
        LatLng(currentPosition!.latitude, currentPosition!.longitude),
        isManual: false,
      );
      await _getAddressFromLatLng(
          currentPosition!.latitude,
          currentPosition!.longitude
      );
      _navigateToBottomNavScreen();
    } else {
      await _fetchCurrentLocation();
      if (currentPosition != null) {
        _handleCurrentLocationTap();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.whiteTheme,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.darkBlueShade),
              SizedBox(height: 20),
              CustomText(
                  text: 'Fetching your location...',
                  fontSize: 16.px,
                  fontWeight: FontWeight.bold
              ),
            ],
          ),
        ),
      );
    }

    final initialPosition = currentPosition != null
        ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
        : const LatLng(0, 0);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.darkBlueShade,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: searchController,
                      googleAPIKey: googleApiKey,
                      inputDecoration: InputDecoration(
                        hintText: 'Search for a location...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        isDense: true,
                        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                        ),
                      ),
                      debounceTime: 600,
                      countries: const ["pk"],
                      itemClick: (val) {
                        if (val.lat != null && val.lng != null) {
                          _setSelectedLocation(
                            LatLng(
                              double.parse(val.lat!),
                              double.parse(val.lng!),
                            ),
                            isManual: true,
                          );
                        }
                      },
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) {
                        if (prediction.lat != null && prediction.lng != null) {
                          _setSelectedLocation(
                            LatLng(
                              double.parse(prediction.lat!),
                              double.parse(prediction.lng!),
                            ),
                            isManual: true,
                          );
                        }
                      },
                      isCrossBtnShown: true,
                      textStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: _handleCurrentLocationTap,
            child: Container(
              height: height * 0.050,
              width: width,
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: AppColors.lightGrey
              ),
              child: Row(
                children: [
                  SizedBox(width: width * 0.03),
                  Icon(Icons.my_location, color: AppColors.darkBlueShade),
                  Text(
                    'Use My Current Location',
                    style: TextStyle(
                      color: AppColors.darkBlueShade,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: selectedLocation ?? initialPosition,
                zoom: 20,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('selectedLocation'),
                  position: selectedLocation ?? initialPosition,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              },
              onTap: (LatLng location) {
                _setSelectedLocation(location, isManual: true);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomText(
                    text: 'Where do you want service?',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.px
                ),
                SizedBox(height: height * 0.020),
                InkWell(
                  onTap: _navigateToBottomNavScreen,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.px),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlueShade,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Confirm Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.px,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}