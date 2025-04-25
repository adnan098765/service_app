import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/CheckOut/service_card.dart';
import 'package:untitled2/CheckOut/total_price.dart';
import 'package:untitled2/CheckOut/schedule_section.dart';
import 'package:untitled2/widgets/custom_container.dart';
import 'package:untitled2/widgets/custom_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'address_selection.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, int> selectedServices;

  const CheckoutScreen({super.key, required this.selectedServices});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  String _address = "Fetching current location";
  bool _isLoadingLocation = true;
  final String _googleMapsApiKey = "AIzaSyClwNhuYxVRorDGtuXSgH8bU7AaTDeJzH0";

  final Map<String, int> servicePrices = {
    "AC Dismounting": 1000,
    "AC General Service": 1850,
    "AC repairing": 1850,
    "Floor standing cabinet Ac general service": 1850,
  };

  @override
  void initState() {
    super.initState();
    // Fetch location as soon as the screen loads
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _address = "Fetching current location...";
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _address = "Location services are disabled";
          _isLoadingLocation = false;
        });
        return;
      }

      // Check for location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _address = "Location permissions are denied";
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _address = "Location permissions are permanently denied";
          _isLoadingLocation = false;
        });
        return;
      }

      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      // Use Google Maps Geocoding API directly with HTTP request
      String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_googleMapsApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          setState(() {
            _address = data['results'][0]['formatted_address'];
            _isLoadingLocation = false;
          });
        } else {
          setState(() {
            _address = "Unable to fetch detailed address";
            _isLoadingLocation = false;
          });
        }
      } else {
        setState(() {
          _address = "Error connecting to location service";
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _address = "Error fetching location. Please try again.";
        _isLoadingLocation = false;
      });
      print("Location error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: AppColors.whiteTheme)),
        centerTitle: true,
        backgroundColor: AppColors.darkBlueShade,
        iconTheme: IconThemeData(color: AppColors.whiteTheme),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScheduleSection(
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  _selectedTime = null;
                });
              },
              onTimeSelected: (time) {
                setState(() => _selectedTime = time);
              },
            ),
            SizedBox(height: 24),
            _buildAddressSection(),
            SizedBox(height: 24),
            Text(
              "Services list",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...widget.selectedServices.entries.map((entry) => ServiceCard(
              title: entry.key,
              description: "Per AC (1 to 2.5 tons)",
              originalPrice: "Rs. 1200",
              discountedPrice: "Rs. 1000",
              rating: 4.8,
              count: entry.value,
              onQuantityChanged: (newCount) {
                setState(() {
                  widget.selectedServices[entry.key] = newCount;
                  if (newCount == 0) {
                    widget.selectedServices.remove(entry.key);
                  }
                });
              },
            )),
            SizedBox(height: 24),
            TotalPriceCard(
              selectedServices: widget.selectedServices,
              servicePrices: servicePrices,
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // Validate all required fields are filled
                if (_selectedDate == null || _selectedTime == null) {
                  Get.snackbar("Gee Hazir Janab", "Please select time and date for the service",
                      backgroundColor: AppColors.appColor, colorText: AppColors.whiteTheme);
                  return;
                }

                if (_address.isEmpty || _isLoadingLocation) {
                  Get.snackbar("Gee Hazir Janab", "Please wait for location to be fetched or provide an address",
                      backgroundColor: AppColors.appColor, colorText: AppColors.whiteTheme);
                  return;
                }

                // You can add the order placement logic here
                print("Placing order for services: ${widget.selectedServices}");
                print("Delivery address: $_address");
                print("Service date: $_selectedDate, time: $_selectedTime");

                // Show confirmation
                Get.snackbar("Gee Hazir Janab", "Your order placed successfully",
                    backgroundColor: AppColors.appColor, colorText: AppColors.whiteTheme);
              },
              child: CustomContainer(
                height: 60,
                width: double.infinity,
                color: AppColors.darkBlueShade,
                borderRadius: 15,
                child: Center(
                  child: CustomText(
                    text: "Place Order",
                    color: AppColors.whiteTheme,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            color: AppColors.whiteTheme,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoadingLocation
                        ? Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBlueShade),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text("Fetching your location", style: TextStyle(fontSize: 16)),
                      ],
                    )
                        : Text(_address, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Text(
                      "Tap edit to change address",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.darkBlueShade),
                onPressed: _editAddress,
              ),
              IconButton(
                icon: Icon(Icons.my_location, color: AppColors.darkBlueShade),
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editAddress() {
    print("Edit address button tapped");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressSelectionSheet(
        currentAddress: _address,
        onSelectAddress: (String newAddress) {
          print("New address selected: $newAddress");
          // Make sure to update the UI with setState
          setState(() {
            _address = newAddress;
            _isLoadingLocation = false;
          });
          print("Address updated to: $_address");
        },
        savedAddresses: [],
        onAddNewAddress: () {
          // This could be implemented later to save addresses
          print("Add new address requested");
        },
      ),
    );
  }
}