// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import '../../constants/app_colors.dart';
// import '../../widgets/custom_text.dart';
// import '../Controlller/add_address_controller.dart';
// import 'add_address_screen.dart';
// import 'categories_page.dart';
// import 'maintenance_page.dart';
// import 'offer_page.dart';
// import 'view_all_services/home_services_screen.dart';
//
// class HomeScreen extends StatelessWidget {
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
//   Widget build(BuildContext context) {
//     final AddAddressController? controller = Get.isRegistered<AddAddressController>()
//         ? Get.find<AddAddressController>()
//         : null;
//     print('HomeScreen: AddAddressController instance: ${controller?.runtimeType}, hashCode: ${controller?.hashCode} @ ${DateTime.now().toIso8601String()}');
//
//     if (controller == null) {
//       print('HomeScreen: Error - AddAddressController not found, using fallback values @ ${DateTime.now().toIso8601String()}');
//     }
//
//     return Scaffold(
//       backgroundColor: AppColors.whiteTheme,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: AppColors.darkBlueShade,
//         title: Obx(
//               () => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(isManualLocation ? Icons.location_on : Icons.my_location, size: 20, color: Colors.white),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text: controller != null && controller.currentAddress.value.isNotEmpty
//                               ? controller.currentAddress.value
//                               : (city ?? 'Select City'),
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           fontSize: 16.sp,
//                         ),
//                         CustomText(
//                           text: controller != null && controller.currentAddress.value.isNotEmpty
//                               ? controller.currentAddress.value
//                               : (address ?? 'Please select an address'),
//                           fontSize: 12.sp,
//                           color: Colors.white70,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             child: CustomText(text: "Add New Address", fontSize: 14.sp, color: AppColors.whiteTheme),
//             onPressed: () {
//               // Navigator.push(context, MaterialPageRoute(builder: (_) => AddAddressScreen()));
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(Adaptive.w(5), Adaptive.h(2), Adaptive.w(5), Adaptive.h(1)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     text: 'Welcome To Our App',
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkBlueShade,
//                   ),
//                   SizedBox(height: Adaptive.h(0.5)),
//                   CustomText(text: 'Find the best services for your needs', fontSize: 14.sp, color: AppColors.hintGrey),
//                 ],
//               ),
//             ),
//             SizedBox(height: Adaptive.h(1)),
//             Padding(padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)), child: OfferBanner()),
//             SizedBox(height: Adaptive.h(3)),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: Adaptive.w(5)),
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
//                       Navigator.push(context, MaterialPageRoute(builder: (_) => HomeServicesScreen()));
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: Adaptive.w(3), vertical: Adaptive.h(0.8)),
//                       decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)),
//                       child: Row(
//                         children: [
//                           CustomText(
//                             text: "View All",
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue[800],
//                           ),
//                           SizedBox(width: Adaptive.w(1)),
//                           Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue[800]),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: Adaptive.h(2)),
//             CategoriesGrid(),
//             SizedBox(height: Adaptive.h(3)),
//             Padding(padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)), child: MaintenanceBanner()),
//             SizedBox(height: Adaptive.h(3)),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_text.dart';
import '../Controlller/add_address_controller.dart';
import 'add_address_screen.dart';
import 'categories_page.dart';
import 'maintenance_page.dart';
import 'offer_page.dart';
import 'view_all_services/home_services_screen.dart';

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
    final AddAddressController? controller = Get.isRegistered<AddAddressController>()
        ? Get.find<AddAddressController>()
        : null;
    print('HomeScreen: AddAddressController instance: ${controller?.runtimeType}, hashCode: ${controller?.hashCode}');

    if (controller == null) {
      print('HomeScreen: Warning - AddAddressController not found, using fallback values');
    }

    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.darkBlueShade,
        title: Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(isManualLocation ? Icons.location_on : Icons.my_location, size: 20, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: controller != null && controller.currentAddress.value.isNotEmpty
                              ? controller.currentAddress.value
                              : (city ?? 'Select City'),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                        CustomText(
                          text: controller != null && controller.currentAddress.value.isNotEmpty
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
          ),
        ),
        actions: [
          TextButton(
            child: CustomText(text: "Add New Address", fontSize: 14.sp, color: AppColors.whiteTheme),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => AddAddressScreen()));
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
                  CustomText(text: 'Find the best services for your needs', fontSize: 14.sp, color: AppColors.hintGrey),
                ],
              ),
            ),
            SizedBox(height: Adaptive.h(1)),
            Padding(padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)), child: OfferBanner()),
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
                      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeServicesScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(3), vertical: Adaptive.h(0.8)),
                      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          CustomText(
                            text: "View All",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                          SizedBox(width: Adaptive.w(1)),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue[800]),
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
            Padding(padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)), child: MaintenanceBanner()),
            SizedBox(height: Adaptive.h(3)),
          ],
        ),
      ),
    );
  }
}