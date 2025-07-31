// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
//
// import '../Home/ViewAllServices/home_services_screen.dart';
//
// class ScheduledScreen extends StatelessWidget {
//   const ScheduledScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SizedBox.expand(  // Ensure full height
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 "No Order Yet",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(
//               height: 150,
//               child: Image.asset('assets/images/img.png', fit: BoxFit.contain), // Use a relevant image
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeServicesScreen()));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.buttonColor,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: const Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
