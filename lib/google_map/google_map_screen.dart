// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:untitled2/widgets/custom_text.dart';
//
// import '../AppColors/app_colors.dart';
// import '../Controllers/google_map_controller.dart';
// import 'add_location.dart';
// import 'fetched_location_screen.dart';
//
// class GoogleMapScreen extends StatelessWidget {
//   final MapController mapController = Get.put(MapController());
//
//   GoogleMapScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: AppColors.whiteTheme,
//       body: Obx(() {
//         if (mapController.isLoading.value) {
//           return Center(
//             child: Stack(
//               children: [
//                 Lottie.asset('assets/images/location.json'),
//                 Positioned(
//                   top: 80.px,
//                   left: 135.px,
//                   child: Column(
//                     children: [
//                       Container(
//                           height: 34.px,
//                           width: 34.px,
//                           decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lowPurple),
//                           child: Center(child: CircleAvatar(backgroundColor: AppColors.whiteTheme, radius: 6.px))),
//                       Container(height: 36.px, width: 2.px, color: AppColors.lowPurple)
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   top: 250.px,
//                   left: 50.px,
//                   child: CustomText(text: 'Fetching your location...', fontSize: 16.px, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.7,
//               child: google_maps.GoogleMap(
//                 onMapCreated: (google_maps.GoogleMapController controller) {
//                   mapController.mapController = controller;
//                 },
//                 initialCameraPosition: google_maps.CameraPosition(
//                     target: google_maps.LatLng(
//                         mapController.currentLocation.value!.latitude, mapController.currentLocation.value!.longitude),
//                     zoom: 15),
//                 markers: {
//                   google_maps.Marker(
//                       markerId: const google_maps.MarkerId('currentLocation'),
//                       position: mapController.currentLocation.value!,
//                       icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(google_maps.BitmapDescriptor.hueBlue))
//                 },
//               ),
//             ),
//             Container(
//                 height: MediaQuery.of(context).size.height * 0.3,
//                 width: width,
//                 decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
//                     color: AppColors.whiteTheme),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 30.0),
//                     CustomText(text: 'Where did you want service?', fontWeight: FontWeight.bold, fontSize: 18.px),
//                     SizedBox(height: height * 0.010),
//                     Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.px),
//                         child: roundButton(
//                             color: AppColors.darkBlueShade,
//                             onTap: () {
//                               Get.to(FetchedLocationScreen(
//                                   latitude: mapController.currentLocation.value?.latitude,
//                                   longitude: mapController.currentLocation.value?.longitude));
//                             },
//                             title: 'At my current location')),
//                     SizedBox(height: height * 0.010),
//                     Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.px),
//                         child: roundButton(
//                             color: AppColors.grey300,
//                             textColor: AppColors.blackColor,
//                             onTap: () {
//                               Get.to(AddLocationScreen(
//                                   latitude: mapController.currentLocation.value!.latitude,
//                                   longitude: mapController.currentLocation.value!.longitude));
//                             },
//                             title: 'I shall enter my location manually')),
//                     SizedBox(height: 50.px),
//                   ],
//                 ))
//           ],
//         );
//       }),
//     );
//   }
// }
