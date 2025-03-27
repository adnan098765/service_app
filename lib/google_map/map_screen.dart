// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import '../AppColors/app_colors.dart';
// import '../BottomNavBar/bottom_nav_screen.dart';
//
// class UnifiedLocationScreen extends StatefulWidget {
//   const UnifiedLocationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UnifiedLocationScreen> createState() => _UnifiedLocationScreenState();
// }
//
// class _UnifiedLocationScreenState extends State<UnifiedLocationScreen> {
//   final searchController = TextEditingController();
//   GoogleMapController? mapController;
//   LatLng selectedLocation = LatLng(37.7749, -122.4194);
//   final String googleApiKey = "AIzaSyClwNhuYxVRorDGtuXSgH8bU7AaTDeJzH0";
//   bool isLoading = true;
//   String? address;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchInitialLocation();
//   }
//
//   Future<void> fetchInitialLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         selectedLocation = LatLng(position.latitude, position.longitude);
//         _getAddressFromLatLng(selectedLocation);
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _getAddressFromLatLng(LatLng latLng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latLng.latitude,
//         latLng.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         setState(() {
//           address = '${place.street}, ${place.locality}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         address = 'Unknown location';
//       });
//     }
//   }
//
//   void _setSelectedLocation(LatLng newLocation) {
//     setState(() {
//       selectedLocation = newLocation;
//     });
//     mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
//     _getAddressFromLatLng(newLocation);
//   }
//
//   void _navigateToNextScreen() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BottomNavScreen(
//           latitude: selectedLocation.latitude,
//           longitude: selectedLocation.longitude,
//           address: address,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.darkBlueShade,
//         title: Text('Select Location'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           GooglePlaceAutoCompleteTextField(
//             textEditingController: searchController,
//             googleAPIKey: googleApiKey,
//             boxDecoration: BoxDecoration(
//               border: Border.all(color: AppColors.whiteTheme),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             inputDecoration: InputDecoration(
//               hintText: 'Search location...',
//               border: InputBorder.none,
//             ),
//             debounceTime: 600,
//             countries: ["pk", "us"],
//             itemClick: (val) {
//               if (val.lat != null && val.lng != null) {
//                 LatLng selected =
//                 LatLng(double.parse(val.lat!), double.parse(val.lng!));
//                 _setSelectedLocation(selected);
//                 _navigateToNextScreen();
//               }
//             },
//             isLatLngRequired: true,
//             getPlaceDetailWithLatLng: (prediction) {
//               if (prediction.lat != null && prediction.lng != null) {
//                 LatLng selected = LatLng(double.parse(prediction.lat!),
//                     double.parse(prediction.lng!));
//                 _setSelectedLocation(selected);
//                 _navigateToNextScreen();
//               }
//             },
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: selectedLocation,
//                 zoom: 15,
//               ),
//               markers: {
//                 Marker(
//                   markerId: MarkerId('selectedLocation'),
//                   position: selectedLocation,
//                 ),
//               },
//               onTap: (latLng) {
//                 _setSelectedLocation(latLng);
//               },
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(16),
//             width: width,
//             child: ElevatedButton(
//               onPressed: _navigateToNextScreen,
//               child: Text('At my current location'),
//               style: ButtonStyle(
//                 backgroundColor:
//                 MaterialStateProperty.all(AppColors.darkBlueShade),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }