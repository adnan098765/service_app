// import 'package:flutter/material.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
// import 'package:untitled2/BottomNavigation/Home/CleaningServices/trending_service_screen.dart';
// import 'package:untitled2/BottomNavigation/Home/ViewAllServices/AcServiceDetails/ac_service_detail_screen.dart';
// import 'package:untitled2/BottomNavigation/Home/ViewAllServices/service_icon.dart';
// import 'package:untitled2/widgets/custom_container.dart';
// import 'package:untitled2/widgets/custom_text.dart';
//
//
// class CleaningServiceScreen extends StatelessWidget {
//   CleaningServiceScreen({super.key});
//   final TextEditingController searchController = TextEditingController();
//
//   final List<Map<String, dynamic>> services = [
//     {'name': 'Solar Panel\nCleaning', 'icon': Icons.solar_power},
//     {'name': 'Sofa Cleaning', 'icon': Icons.bed},
//     {'name': 'Plastic Water\nTank Cleaning', 'icon': Icons.propane_tank_rounded},
//     {'name': 'Mattress cleaning', 'icon': Icons.bed},
//     {'name': 'Deep Cleaning', 'icon': Icons.house},
//     {'name': 'Curtain Cleaning', 'icon': Icons.curtains_closed_outlined},
//     {'name': 'Commercial Deep\nCleaning', 'icon': Icons.house},
//     {'name': 'Chair Cleaning', 'icon': Icons.chair},
//     {'name': 'Cement water cleaning', 'icon': Icons.add_chart_sharp},
//     {'name': 'Carpet Cleaning', 'icon': Icons.class_rounded},
//     {'name': 'Car Detailing', 'icon': Icons.car_crash_outlined},
//   ];
//
//   // Function to navigate based on index
//   void _navigateTo(BuildContext context, int index) {
//     List<Widget> screens = [
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//       const ACServiceScreen(),
//     ];
//
//     if (index < screens.length) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => screens[index]),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ServiceDetailsScreen(
//             serviceName: services[index]['name'],
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: AppColors.whiteTheme,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 20.0),
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               title: const CustomText(text: "Cleaning Services"),
//               floating: true,
//               pinned: true,
//               leading: const Icon(Icons.arrow_back),
//               actions: const [
//                 Icon(Icons.phone),
//                 SizedBox(width: 10),
//                 Icon(Icons.notifications),
//                 SizedBox(width: 10),
//               ],
//             ),
//             SliverPersistentHeader(
//               pinned: true,
//               floating: false,
//               delegate: _SearchBarDelegate(searchController),
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 const SizedBox(height: 10),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: CustomText(text:
//                     'All Services',
//                     fontSize: 18, fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 GridView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 0),
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: services.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 20,
//                     mainAxisExtent: 150// Adjust spacing
//                   ),
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () => _navigateTo(context, index),
//                       child: ServiceIcon(
//                         name: services[index]['name'],
//                         icon: services[index]['icon'],
//                       ),
//                     );
//                   },
//                 ),
//                 TrendingServiceScreen(),
//                 SizedBox(height: height * 0.030,)
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
//   final TextEditingController controller;
//
//   _SearchBarDelegate(this.controller);
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.all(12.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.text,
//         decoration: InputDecoration(
//           fillColor: Colors.grey.shade300,
//           filled: true,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(
//               color: AppColors.whiteTheme,
//               width: 1,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(
//               color: AppColors.lightWhite,
//               width: 2,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(
//               color: AppColors.lightWhite,
//               width: 1,
//             ),
//           ),
//           hintText: "Search",
//         ),
//       ),
//     );
//   }
//
//   @override
//   double get maxExtent => 70;
//
//   @override
//   double get minExtent => 70;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
// }
// class ServiceDetailsScreen extends StatelessWidget {
//   final String serviceName;
//
//   const ServiceDetailsScreen({super.key, required this.serviceName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(serviceName),
//       ),
//       body: Center(
//         child: Text(
//           'Details for $serviceName',
//           style: const TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
