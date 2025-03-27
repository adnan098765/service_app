// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
//
// import '../AppColors/app_colors.dart';
// import '../BottomNavBar/bottom_nav_screen.dart';
//
//
// class AddLocationScreen extends StatefulWidget {
//   final double latitude;
//   final double longitude;
//   const AddLocationScreen({
//     super.key,
//     required this.latitude,
//     required this.longitude,
//   });
//
//   @override
//   State<AddLocationScreen> createState() => _AddLocationScreenState();
// }
//
// class _AddLocationScreenState extends State<AddLocationScreen> {
//   final searchController = TextEditingController();
//   GoogleMapController? mapController;
//   LatLng? selectedLocation;
//   final String googleApiKey = "AIzaSyClwNhuYxVRorDGtuXSgH8bU7AaTDeJzH0";
//
//   void _navigateToNextScreen(double latitude, double longitude) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => BottomNavScreen(
//                 latitude: latitude,
//                 longitude: longitude,
//               )),
//     );
//   }
//
//   void _setSelectedLocation(LatLng? newLocation) {
//     setState(() {
//       selectedLocation = newLocation;
//     });
//     mapController?.animateCamera(CameraUpdate.newLatLng(newLocation!));
//     Future.delayed(const Duration(seconds: 5), () {
//       _navigateToNextScreen(
//         newLocation!.latitude,
//         newLocation.longitude,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: AppColors.darkBlueShade,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(35.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   const SizedBox(width: 5),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Icon(Icons.arrow_back, color: AppColors.whiteTheme),
//                   ),
//                   SizedBox(width: width * 0.02),
//                   Expanded(
//                     child: GooglePlaceAutoCompleteTextField(
//                       textEditingController: searchController,
//                       googleAPIKey: googleApiKey,
//                       boxDecoration: BoxDecoration(
//                         border: Border.all(color: AppColors.whiteTheme),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       inputDecoration: const InputDecoration(
//                         icon: Icon(
//                           Icons.search,
//                           color: AppColors.greyColor,
//                         ),
//                         hintText: 'Search...',
//                         hintStyle: TextStyle(color: AppColors.greyColor, fontSize: 16),
//                         border: InputBorder.none,
//                       ),
//                       debounceTime: 600,
//                       countries: const ["pk", "us"],
//                       itemClick: (val) {
//                         if (val.lat != null && val.lng != null) {
//                           LatLng selected = LatLng(
//                             double.parse(val.lat ?? '${widget.latitude}'),
//                             double.parse(val.lng ?? '${widget.longitude}'),
//                           );
//                           _setSelectedLocation(selected);
//                         }
//                       },
//                       isLatLngRequired: true,
//                       getPlaceDetailWithLatLng: (prediction) {
//                         if (prediction.lat != null && prediction.lng != null) {
//                           LatLng selected = LatLng(
//                             double.parse(prediction.lat!),
//                             double.parse(prediction.lng!),
//                           );
//                           _setSelectedLocation(selected);
//                         } else {
//                           log("Latitude or longitude is null for selected place.");
//                         }
//                       },
//                       isCrossBtnShown: true,
//                       textStyle: const TextStyle(color: AppColors.whiteTheme),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.search, color: AppColors.whiteTheme),
//                     onPressed: () {
//                       if (selectedLocation != null) {
//                         _setSelectedLocation(selectedLocation);
//                       } else {}
//                     },
//                   ),
//                 ],
//               ),
//               // SizedBox(height: height * 0.010),
//               SizedBox(height: height * 0.015),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => BottomNavScreen(
//                             latitude: widget.latitude,
//                             longitude: widget.longitude,
//                           )));
//             },
//             child: Container(
//               height: height * 0.050,
//               width: width,
//               decoration: BoxDecoration(border: Border.all(), color: AppColors.lightGrey),
//               child: Row(
//                 children: [
//                   SizedBox(width: width * 0.03),
//                   const Icon(Icons.lightbulb, color: AppColors.yellowColor),
//                   Text(
//                     'Use current Location',
//                     style: TextStyle(color: AppColors.darkBlueShade),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           Expanded(
//             child: GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: selectedLocation ?? LatLng(widget.latitude, widget.longitude),
//                 zoom: 15,
//               ),
//               markers: selectedLocation != null
//                   ? {
//                       Marker(markerId: const MarkerId('selectedLocation'), position: selectedLocation!),
//                     }
//                   : {
//                       Marker(
//                           markerId: const MarkerId('selectedLocation'),
//                           position: LatLng(
//                             widget.latitude,
//                             widget.longitude,
//                           ),
//                           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)),
//                     },
//             ),
//           ),
//           const SizedBox(height: 16.0),
//         ],
//       ),
//     );
//   }
// }
