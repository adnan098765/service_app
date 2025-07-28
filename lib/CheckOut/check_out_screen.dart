import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/CheckOut/schedule_section.dart';
import 'package:untitled2/CheckOut/service_card.dart';
import 'package:untitled2/CheckOut/total_price.dart';
import 'package:untitled2/widgets/custom_container.dart';
import 'package:untitled2/widgets/custom_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Controlller/add_address_controller.dart';
import '../Models/all_category_services.dart';
import 'address_selection.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, int> selectedServices;
  final List<Map<String, Object>> selectedServiceDetails;

  const CheckoutScreen({
    super.key,
    required this.selectedServices,
    required this.selectedServiceDetails,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  final String _googleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY"; // Replace with actual API key
  late final AddAddressController _addressController;

  @override
  void initState() {
    super.initState();
    _addressController = Get.put(AddAddressController());
    _getCurrentLocation();
    debugPrint('CheckoutScreen: Initialized with selectedServices=${widget.selectedServices}, selectedServiceDetails=${widget.selectedServiceDetails}');
  }

  Future<void> _getCurrentLocation() async {
    _addressController.currentAddress.value = "Fetching current location...";

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _addressController.currentAddress.value = "Location services are disabled";
        debugPrint('CheckoutScreen: Location services disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _addressController.currentAddress.value = "Location permissions are denied";
          debugPrint('CheckoutScreen: Location permissions denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _addressController.currentAddress.value = "Location permissions are permanently denied";
        debugPrint('CheckoutScreen: Location permissions permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      debugPrint('CheckoutScreen: Got position: lat=${position.latitude}, lng=${position.longitude}');

      String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_googleMapsApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          String fetchedAddress = data['results'][0]['formatted_address'];
          _addressController.updateCurrentAddress(fetchedAddress);
          await _addressController.addAddress(
            addressType: 'current',
            address: fetchedAddress,
            latitude: position.latitude,
            longitude: position.longitude,
            isDefault: _addressController.savedAddresses.isEmpty,
          );
          debugPrint('CheckoutScreen: Fetched address: $fetchedAddress');
        } else {
          _addressController.currentAddress.value = "Unable to fetch detailed address";
          debugPrint('CheckoutScreen: Failed to fetch address, status=${data['status']}');
        }
      } else {
        _addressController.currentAddress.value = "Error connecting to location service";
        debugPrint('CheckoutScreen: HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      _addressController.currentAddress.value = "Error fetching location. Please try again.";
      debugPrint('CheckoutScreen: Location error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: AppColors.whiteTheme)),
        centerTitle: true,
        backgroundColor: AppColors.darkBlueShade,
        iconTheme: const IconThemeData(color: AppColors.whiteTheme),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                debugPrint('CheckoutScreen: Selected date: $date');
              },
              onTimeSelected: (time) {
                setState(() => _selectedTime = time);
                debugPrint('CheckoutScreen: Selected time: $time');
              },
            ),
            const SizedBox(height: 24),
            _buildAddressSection(),
            const SizedBox(height: 24),
            const Text(
              "Services list",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...widget.selectedServices.entries.map((entry) {
              // Find the service details from selectedServiceDetails
              final serviceDetail = widget.selectedServiceDetails.firstWhere(
                    (detail) => (detail['service'] as Services?)?.serviceName == entry.key,
                orElse: () => <String, Object>{'service': entry.key, 'quantity': 0},
              );
              final service = serviceDetail['service'] as Services?;
              if (service == null) {
                debugPrint('CheckoutScreen: No service details found for ${entry.key}');
                return const SizedBox.shrink();
              }
              return ServiceCard(
                title: entry.key,
                description: service.description ?? 'No description',
                originalPrice: 'Rs. ${service.regularPrice ?? '0'}',
                discountedPrice: 'Rs. ${service.salePrice ?? service.regularPrice ?? '0'}',
                rating: service.isFeatured == true ? 4.8 : 4.3,
                count: entry.value,
                onQuantityChanged: (newCount) {
                  setState(() {
                    if (newCount == 0) {
                      widget.selectedServices.remove(entry.key);
                    } else {
                      widget.selectedServices[entry.key] = newCount;
                    }
                  });
                  debugPrint('CheckoutScreen: Updated quantity for ${entry.key} to $newCount');
                },
              );
            }),
            const SizedBox(height: 24),
            TotalPriceCard(
              selectedServices: widget.selectedServices,
              selectedServiceDetails: widget.selectedServiceDetails,
            ),
            const SizedBox(height: 24),
            Obx(() => GestureDetector(
              onTap: _addressController.isLoading.value
                  ? null
                  : () {
                if (_selectedDate == null || _selectedTime == null) {
                  Get.snackbar(
                    "Gee Hazir Janab",
                    "Please select time and date for the service",
                    backgroundColor: AppColors.appColor,
                    colorText: AppColors.whiteTheme,
                  );
                  return;
                }

                if (_addressController.currentAddress.value.isEmpty ||
                    _addressController.currentAddress.value.contains("Fetching") ||
                    _addressController.currentAddress.value.contains("Error")) {
                  Get.snackbar(
                    "Gee Hazir Janab",
                    "Please wait for location to be fetched or provide an address",
                    backgroundColor: AppColors.appColor,
                    colorText: AppColors.whiteTheme,
                  );
                  return;
                }

                // Simulate order placement (replace with actual API call)
                debugPrint('CheckoutScreen: Order Details:');
                debugPrint('Services: ${widget.selectedServices}');
                debugPrint('Service Details: ${widget.selectedServiceDetails}');
                debugPrint('Address: ${_addressController.currentAddress.value}');
                debugPrint('Date: $_selectedDate, Time: $_selectedTime');

                Get.snackbar(
                  "Gee Hazir Janab",
                  "Your order placed successfully",
                  backgroundColor: AppColors.appColor,
                  colorText: AppColors.whiteTheme,
                );
              },
              child: CustomContainer(
                height: 60,
                width: double.infinity,
                color: _addressController.isLoading.value
                    ? AppColors.darkBlueShade.withOpacity(0.6)
                    : AppColors.darkBlueShade,
                borderRadius: 15,
                child: Center(
                  child: _addressController.isLoading.value
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteTheme),
                  )
                      : const CustomText(
                    text: "Place Order",
                    color: AppColors.whiteTheme,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Address",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(() => Container(
          padding: const EdgeInsets.all(12),
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
                    _addressController.currentAddress.value.contains("Fetching")
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
                        const SizedBox(width: 8),
                        const Text("Fetching your location", style: TextStyle(fontSize: 16)),
                      ],
                    )
                        : Text(
                      _addressController.currentAddress.value.isEmpty
                          ? "No address selected"
                          : _addressController.currentAddress.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const Text(
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
        )),
      ],
    );
  }

  void _editAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressSelectionSheet(
        currentAddress: _addressController.currentAddress.value,
        onSelectAddress: (String newAddress, double latitude, double longitude) {
          _addressController.updateCurrentAddress(newAddress);
          _saveSelectedAddress(newAddress, latitude, longitude);
        },
        savedAddresses: _addressController.getAddressesForUI(),
        onAddNewAddress: () {
          debugPrint('CheckoutScreen: Add new address requested');
        },
      ),
    );
  }

  Future<void> _saveSelectedAddress(String address, double latitude, double longitude) async {
    try {
      await _addressController.addAddress(
        addressType: 'selected',
        address: address,
        latitude: latitude,
        longitude: longitude,
        isDefault: _addressController.savedAddresses.isEmpty,
      );
      debugPrint('CheckoutScreen: Saved address: $address');
    } catch (e) {
      debugPrint('CheckoutScreen: Error saving selected address: $e');
      Get.snackbar('Error', 'Failed to save address');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}