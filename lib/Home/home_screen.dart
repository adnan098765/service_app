import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';
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
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.isManualLocation ? Icons.location_on : Icons.my_location,
                  size: 20,
                  color: AppColors.darkBlueShade,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.city ?? 'Current Location',
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        text: widget.address ?? 'Address not available',
                        fontSize: 12.px,
                        color: AppColors.hintGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart
            },
          ),
        ],
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
                  Text(
                    'Welcome To Our App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Find the best services for your needs',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Location Type Indicator
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Chip(
            //     label: Text(
            //       widget.isManualLocation ? 'Manual Location' : 'Current Location',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     backgroundColor: widget.isManualLocation
            //         ? Colors.orange
            //         : Colors.green,
            //   ),
            // ),
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
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
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