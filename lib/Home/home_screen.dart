import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';
import 'package:untitled2/Controlller/add_address_controller.dart';
import 'categories_page.dart';
import 'maintenance_page.dart';
import 'offer_page.dart';
import 'ViewAllServices/home_services_screen.dart';

class HomeScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final bool isManualLocation;

  const HomeScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    required this.isManualLocation,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AddAddressController addAddressController = Get.find<AddAddressController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.darkBlueShade,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.isManualLocation ? Icons.location_on : Icons.my_location,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: addAddressController.currentAddress.value.isNotEmpty
                            ? addAddressController.currentAddress.value
                            : (widget.city ?? 'Select Location'),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16.px,
                      ),
                      CustomText(
                        text: addAddressController.currentAddress.value.isNotEmpty
                            ? addAddressController.currentAddress.value
                            : (widget.address ?? 'Address not available'),
                        fontSize: 12.px,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Welcome To Our App',
                    fontSize: 24.px,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlueShade,
                  ),
                  SizedBox(height: 5),
                  CustomText(
                    text: 'Find the best services for your needs',
                    fontSize: 14.px,
                    color: AppColors.hintGrey,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Rest of your home screen content...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OfferBanner(),
            ),
            SizedBox(height: height * 0.030),

            // Categories Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Categories",
                    fontSize: 18.px,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlueShade,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeServicesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CustomText(
                            text: "View All",
                            fontSize: 14.px,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.blue[800],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.020),
            CategoriesGrid(),
            SizedBox(height: height * 0.030),

            // Maintenance Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MaintenanceBanner(),
            ),
            SizedBox(height: height * 0.030),
          ],
        ),
      ),
    );
  }
}