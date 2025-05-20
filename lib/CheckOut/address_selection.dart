import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:untitled2/AppColors/app_colors.dart';

class AddressSelectionSheet extends StatefulWidget {
  final String currentAddress;
  final Function(String) onSelectAddress;
  final List<Map<String, String>> savedAddresses;
  final Function() onAddNewAddress;

  const AddressSelectionSheet({
    Key? key,
    required this.currentAddress,
    required this.onSelectAddress,
    required this.savedAddresses,
    required this.onAddNewAddress,
  }) : super(key: key);

  @override
  _AddressSelectionSheetState createState() => _AddressSelectionSheetState();
}

class _AddressSelectionSheetState extends State<AddressSelectionSheet> {
  final String googleApiKey = "AIzaSyClwNhuYxVRorDGtuXSgH8bU7AaTDeJzH0";
  final TextEditingController _searchController = TextEditingController();

  LatLng? _selectedLocation;
  String? _selectedAddress;
  GoogleMapController? _mapController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.currentAddress;
    _selectedAddress = widget.currentAddress;
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      // Request location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          Get.snackbar('Location Disabled', 'Please enable location services');
        }
        _setDefaultLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            Get.snackbar(
              'Permission Denied',
              'Location permissions are denied',
            );
          }
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          Get.snackbar(
            'Permission Denied',
            'Location permissions are permanently denied',
          );
        }
        _setDefaultLocation();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      await _updateLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      print('Error fetching location: $e');
      _setDefaultLocation();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setDefaultLocation() {
    _updateLocation(LatLng(31.5204, 74.3587));
  }

  Future<void> _updateLocation(LatLng location) async {
    if (!mounted) return;

    setState(() {
      _selectedLocation = location;
    });
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16),
      );
    }

    await _getAddressFromLatLng(location.latitude, location.longitude);
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        String addr = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.country,
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        setState(() {
          _selectedAddress = addr;
          _searchController.text = addr;
        });
      }
    } catch (e) {
      print('Error getting address: $e');
      if (mounted) {
        Get.snackbar('Error', 'Could not fetch address details');
      }
    }
  }

  // This method handles the search result selection and automatically confirms
  void _handlePlaceSelection(Prediction prediction) async {
    if (prediction.description != null) {
      _searchController.text = prediction.description!;
      setState(() => _selectedAddress = prediction.description);
    }

    if (prediction.lat != null && prediction.lng != null) {
      double lat = double.parse(prediction.lat!);
      double lng = double.parse(prediction.lng!);

      // Explicitly move the map to the selected location
      await _updateLocation(LatLng(lat, lng));

      // Add a delay to make sure the map has time to update
      await Future.delayed(const Duration(milliseconds: 300));

      // Ensure the marker is updated
      setState(() {});

      // Automatically confirm this address and close the sheet
      _confirmAddress();
    } else {
      // If lat/lng not available, try to get coordinates from the address
      try {
        List<Location> locations = await locationFromAddress(
          prediction.description ?? "",
        );
        if (locations.isNotEmpty) {
          await _updateLocation(
            LatLng(locations.first.latitude, locations.first.longitude),
          );
          setState(() {});

          // Automatically confirm this address and close the sheet
          _confirmAddress();
        }
      } catch (e) {
        print("Error getting location from address: $e");
        Get.snackbar('Error', 'Could not find location for this address');
      }
    }
  }

  // Helper method to handle address confirmation
  void _confirmAddress() {
    if (_selectedAddress != null && _selectedAddress!.isNotEmpty) {
      widget.onSelectAddress(_selectedAddress!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColors.whiteTheme,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  "Select Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _fetchCurrentLocation,
                  tooltip: 'Current Location',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _searchController,
              googleAPIKey: googleApiKey,
              inputDecoration: InputDecoration(
                hintText: 'Search location...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _selectedAddress = null);
                  },
                )
                    : null,
              ),
              debounceTime: 800,
              countries: const ["pk"],
              isLatLngRequired: true,
              itemClick: _handlePlaceSelection,
            ),
          ),

          SizedBox(height: 10,),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                mapType: MapType.hybrid,
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (_selectedLocation != null) {
                    controller.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        _selectedLocation!,
                        16,
                      ),
                    );
                  }
                },
                initialCameraPosition: CameraPosition(
                  target:
                  _selectedLocation ??
                      const LatLng(31.5204, 74.3587),
                  zoom: 20,
                ),
                markers:
                _selectedLocation != null
                    ? {
                  Marker(
                    markerId: const MarkerId(
                      'selected_location',
                    ),
                    position: _selectedLocation!,
                    infoWindow: InfoWindow(
                      title: "Selected Location",
                      snippet: _selectedAddress,
                    ),
                  ),
                }
                    : {},
                onTap: (latLng) async {
                  await _updateLocation(latLng);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: true,
                zoomControlsEnabled: false,
                buildingsEnabled: true,
                rotateGesturesEnabled: true,
              ),
            ),
          ),

          // Selected Address Preview
          // if (_selectedAddress != null && _selectedAddress!.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(
          //       vertical: 16.0,
          //       horizontal: 8,
          //     ),
          //     child: Container(
          //       padding: const EdgeInsets.all(12),
          //       decoration: BoxDecoration(
          //         color: Colors.grey[100],
          //         borderRadius: BorderRadius.circular(8),
          //         border: Border.all(color: Colors.grey[300]!),
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text(
          //             "Selected Address:",
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: 14,
          //             ),
          //           ),
          //           const SizedBox(height: 4),
          //           Text(
          //             _selectedAddress!,
          //             style: const TextStyle(fontSize: 16),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),

          // Tap instruction

        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }
}