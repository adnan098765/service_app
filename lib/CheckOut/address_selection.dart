import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:get/get.dart';
import 'package:untitled2/AppColors/app_colors.dart';

class AddressSelectionSheet extends StatefulWidget {
  final String currentAddress;
  final List<Map<String, String>> savedAddresses;
  final Function(String) onSelectAddress;
  final Function() onAddNewAddress;

  const AddressSelectionSheet({
    Key? key,
    required this.currentAddress,
    required this.savedAddresses,
    required this.onSelectAddress,
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

  @override
  void initState() {
    super.initState();
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
        setState(() {
          _selectedAddress = '${place.street}, ${place.subLocality}, '
              '${place.locality}, ${place.postalCode}, ${place.country}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  void _saveSelectedAddress() {
    if (_selectedAddress != null && _selectedLocation != null) {
      widget.onSelectAddress(_selectedAddress!);
      Navigator.pop(context);
    } else {
      Get.snackbar('Error', 'Please select a location');
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
          Text(
            "Select Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Improved Google Places Search
          GooglePlaceAutoCompleteTextField(
            textEditingController: _searchController,
            googleAPIKey: googleApiKey,
            inputDecoration: InputDecoration(
              hintText: 'Search location...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            debounceTime: 600,
            countries: ["pk"],
            isLatLngRequired: true,
            itemClick: (prediction) {
              _searchController.text = prediction.description ?? "";
              _searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: _searchController.text.length),
              );
              if (prediction.lat != null && prediction.lng != null) {
                _updateLocation(
                  LatLng(
                    double.parse(prediction.lat!),
                    double.parse(prediction.lng!),
                  ),
                );
              }
            },
          ),
          SizedBox(height: 16),

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
              onTap: _updateLocation,
            ),
          ),

          if (_selectedAddress != null) ...[
            SizedBox(height: 16),
            Text(
              'Selected Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _selectedAddress!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveSelectedAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkBlueShade,
                  ),
                  child: Text('Confirm'),
                ),
              ),
            ],
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