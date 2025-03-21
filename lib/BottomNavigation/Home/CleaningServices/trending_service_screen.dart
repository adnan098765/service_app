// import 'package:flutter/material.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
// import 'package:untitled2/BottomNavigation/Home/CleaningServices/trending_custom_widget.dart';
// import 'package:untitled2/widgets/custom_text.dart';
// import '../../../widgets/custom_container.dart';
//
// class TrendingServiceScreen extends StatefulWidget {
//   @override
//   State<TrendingServiceScreen> createState() => _TrendingServiceScreenState();
// }
//
// class _TrendingServiceScreenState extends State<TrendingServiceScreen> {
//   final List<Map<String, dynamic>> services = [
//     {
//       "id": 1,
//       "image": "assets/images/img.png",
//       "title": "5 Seater Sofa Set Cleaning",
//       "orders": "25455",
//       "rating": 4.4,
//       "description": "Included 18x18 Inch Cushion",
//       "oldPrice": 2250.0,
//       "newPrice": 1500.0,
//     },
//     {
//       "id": 2,
//       "image": "assets/images/img.png",
//       "title": "Car Detailing Sedan",
//       "orders": "11163",
//       "rating": 4.4,
//       "description": "Per Car",
//       "oldPrice": 7300.0,
//       "newPrice": 6000.0,
//     },
//     {
//       "id": 3,
//       "image": "assets/images/img.png",
//       "title": "Single Mattress Cleaning",
//       "orders": "11435",
//       "rating": 4.2,
//       "description": "Per Mattress",
//       "oldPrice": 2000.0,
//       "newPrice": 1650.0,
//     },
//     {
//       "id": 4,
//       "image": "assets/images/img.png",
//       "title": "Plastic Water Tank Cleaning",
//       "orders": "20802",
//       "rating": 4.5,
//       "description": "(150-300) Gallons",
//       "oldPrice": 1650.0,
//       "newPrice": 1650.0,
//     },
//     {
//       "id": 5,
//       "image": "assets/images/img.png",
//       "title": "Carpet Cleaning",
//       "orders": "23309",
//       "rating": 4.5,
//       "description": "",
//       "oldPrice": 25.0,
//       "newPrice": 20.0,
//     },
//   ];
//
//
//   Map<int, int> selectedItems = {};
//
//   void toggleItemSelection(int id) {
//     setState(() {
//       if (selectedItems.containsKey(id)) {
//         selectedItems.remove(id);
//       } else {
//
//         selectedItems[id] = 1;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(padding: EdgeInsets.all(12.0)),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 12),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Trending Services",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               GridView.builder(
//                 padding: EdgeInsets.all(8),
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemCount: services.length,
//                 itemBuilder: (context, index) {
//                   var service = services[index];
//                   int serviceId = service["id"];
//
//                   return GestureDetector(
//                     onTap: () => toggleItemSelection(serviceId),
//                     child: Stack(
//                       children: [
//                         TrendingCustomWidget(
//                           imageUrl: service["image"],
//                           title: service["title"],
//                           orders: service["orders"],
//                           rating: service["rating"],
//                           description: service["description"],
//                           oldPrice: service["oldPrice"],
//                           newPrice: service["newPrice"],
//                         ),
//                         if (selectedItems.containsKey(serviceId))
//                           Positioned(
//                             top: 140,
//                             right: 20,
//
//                               child: Icon(Icons.shopping_cart, color: AppColors.darkBlueShade, size: 16),
//
//                           ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 80),
//             ],
//           ),
//         ),
//         if (selectedItems.isNotEmpty)
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: InkWell(
//               onTap: () {
//                 print("Selected Items: $selectedItems");
//               },
//               child: CustomContainer(
//                 height: 40,
//                 width: 160,
//                 color: AppColors.appColor,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     CustomContainer(
//                       height: 30,
//                       width: 30,
//                       color: AppColors.appColor,
//                       child: Center(
//                         child: CustomText(
//                           text: "${selectedItems.length}",
//                           color: AppColors.whiteTheme,
//                         ),
//                       ),
//                     ),
//                     CustomText(text: "Review Card", color: AppColors.whiteTheme),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
