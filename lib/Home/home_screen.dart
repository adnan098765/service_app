// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
// import 'package:untitled2/widgets/custom_text.dart';
// import 'package:untitled2/Controlller/add_address_controller.dart';
// import 'package:untitled2/Home/categories_page.dart';
// import 'package:untitled2/Home/maintenance_page.dart';
// import 'package:untitled2/Home/offer_page.dart';
// import 'package:untitled2/Home/ViewAllServices/home_services_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   final String? address;
//   final String? city;
//   final bool isManualLocation;
//
//   const HomeScreen({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//     this.address,
//     this.city,
//     required this.isManualLocation,
//   });
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final AddAddressController addAddressController = Get.find<AddAddressController>();
//
//   void _addNewAddress() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         final TextEditingController addressController = TextEditingController();
//         return AlertDialog(
//           title: const Text('Add New Address'),
//           content: TextField(
//             controller: addressController,
//             decoration: const InputDecoration(
//               hintText: 'Enter address',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 if (addressController.text.isNotEmpty) {
//                   final success = await addAddressController.addAddress(
//                     addressType: 'home',
//                     address: addressController.text,
//                     latitude: widget.latitude,
//                     longitude: widget.longitude,
//                     isDefault: true,
//                   );
//                   if (success) {
//                     addAddressController.updateCurrentAddress(addressController.text);
//                     Navigator.pop(context);
//                   }
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteTheme,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: AppColors.darkBlueShade,
//         title: Obx(() {
//           final address = addAddressController.currentAddress.value.isNotEmpty
//               ? addAddressController.currentAddress.value
//               : (widget.address ?? 'No Address Available');
//           final city = addAddressController.currentAddress.value.isNotEmpty
//               ? addAddressController.currentAddress.value
//               : (widget.city ?? 'Tap to add address');
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     widget.isManualLocation ? Icons.location_on : Icons.my_location,
//                     size: 20.sp,
//                     color: Colors.white,
//                   ),
//                   SizedBox(width: 8.sp),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: _addNewAddress,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomText(
//                             text: address,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                             fontSize: 16.sp,
//                           ),
//                           CustomText(
//                             text: city,
//                             fontSize: 12.sp,
//                             color: Colors.white70,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         }),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 10.sp),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     text: 'Welcome To Our App',
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkBlueShade,
//                   ),
//                   SizedBox(height: 5.sp),
//                   CustomText(
//                     text: 'Find the best services for your needs',
//                     fontSize: 14.sp,
//                     color: AppColors.hintGrey,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10.sp),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.sp),
//               child: OfferBanner(),
//             ),
//             SizedBox(height: 3.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.sp),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   CustomText(
//                     text: "Categories",
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkBlueShade,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const HomeServicesScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 12.sp,
//                         vertical: 6.sp,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           CustomText(
//                             text: "View All",
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue[800],
//                           ),
//                           SizedBox(width: 4.sp),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             size: 14.sp,
//                             color: Colors.blue[800],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 2.h),
//             CategoriesGrid(),
//             SizedBox(height: 3.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.sp),
//               child: MaintenanceBanner(),
//             ),
//             SizedBox(height: 3.h),
//           ],
//         ),
//       ),
//     );
//   }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../AppColors/app_colors.dart';
import '../Controlller/add_address_controller.dart';
import '../widgets/custom_text.dart';
import 'ViewAllServices/home_services_screen.dart';
import 'categories_page.dart';
import 'maintenance_page.dart';
import 'offer_page.dart';
import 'add_address_screen.dart';

class HomeScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final AddAddressController controller = Get.find<AddAddressController>();
    double height = MediaQuery.of(context).size.height;

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
                  isManualLocation ? Icons.location_on : Icons.my_location,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: controller.currentAddress.value.isNotEmpty
                            ? controller.currentAddress.value
                            : (city ?? 'Select City'),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                      CustomText(
                        text: controller.currentAddress.value.isNotEmpty
                            ? controller.currentAddress.value
                            : (address ?? 'Please select an address'),
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )),
        actions: [
          TextButton(
            child:CustomText(text: "Add New Address",fontSize: 14.sp,color: AppColors.whiteTheme,) ,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddAddressScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Adaptive.w(5), Adaptive.h(2), Adaptive.w(5), Adaptive.h(1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Welcome To Our App',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlueShade,
                  ),
                  SizedBox(height: Adaptive.h(0.5)),
                  CustomText(
                    text: 'Find the best services for your needs',
                    fontSize: 14.sp,
                    color: AppColors.hintGrey,
                  ),
                ],
              ),
            ),
            SizedBox(height: Adaptive.h(1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
              child: OfferBanner(),
            ),
            SizedBox(height: Adaptive.h(3)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Categories",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlueShade,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomeServicesScreen()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Adaptive.w(3),
                        vertical: Adaptive.h(0.8),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CustomText(
                            text: "View All",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                          SizedBox(width: Adaptive.w(1)),
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
            SizedBox(height: Adaptive.h(2)),
            CategoriesGrid(),
            SizedBox(height: Adaptive.h(3)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
              child: MaintenanceBanner(),
            ),
            SizedBox(height: Adaptive.h(3)),
          ],
        ),
      ),
    );
  }
}