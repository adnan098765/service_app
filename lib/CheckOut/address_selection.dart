import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:get/get.dart';
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
  bool _manualMode = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.currentAddress;
    _selectedAddress = widget.currentAddress;
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _updateLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      print('Error fetching current location: $e');
      _updateLocation(LatLng(31.5204, 74.3587)); // Lahore default
    }
  }

  Future<void> _updateLocation(LatLng location) async {
    setState(() {
      _selectedLocation = location;
    });
    await _getAddressFromLatLng(location.latitude, location.longitude);
    _mapController?.animateCamera(CameraUpdate.newLatLng(location));
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String addr = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        setState(() {
          _selectedAddress = addr;
          _searchController.text = addr;
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteTheme,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Select Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _manualMode = !_manualMode;
                  });
                },
                child: Text(_manualMode ? "Use Map" : "Enter Manually"),
              ),
            ],
          ),
          SizedBox(height: 16),

          GooglePlaceAutoCompleteTextField(
            textEditingController: _searchController,
            googleAPIKey: googleApiKey,
            inputDecoration: InputDecoration(
              hintText: _manualMode ? 'Enter address manually' : 'Search location...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            debounceTime: 600,
            countries: ["pk"],
            isLatLngRequired: true,
            // getPlaceDetailWithLatLng: true,
            itemClick: (prediction) async {
              _searchController.text = prediction.description ?? "";
              setState(() {
                _selectedAddress = prediction.description;
              });

              if (prediction.lat != null && prediction.lng != null && !_manualMode) {
                await _updateLocation(
                  LatLng(
                    double.parse(prediction.lat!),
                    double.parse(prediction.lng!),
                  ),
                );
              }
            },
          ),

          SizedBox(height: 16),

          if (!_manualMode)
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) => _mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation ?? LatLng(31.5204, 74.3587),
                  zoom: 15,
                ),
                markers: _selectedLocation != null
                    ? {
                  Marker(
                    markerId: MarkerId('selected_location'),
                    position: _selectedLocation!,
                  )
                }
                    : {},
                onTap: (latLng) async {
                  await _updateLocation(latLng);
                },
              ),
            ),
          if (_manualMode) SizedBox(height: 250), // space placeholder

          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final address = _searchController.text.trim();
              if (address.isNotEmpty) {
                widget.onSelectAddress(address);
                Navigator.pop(context);
              } else {
                Get.snackbar('Error', 'Please enter or select an address');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlueShade,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Confirm Address', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
