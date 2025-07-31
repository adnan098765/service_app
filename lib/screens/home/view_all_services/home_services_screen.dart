// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:untitled2/widgets/custom_text.dart';
// import '../../../constants/app_colors.dart';
// import '../../Controlller/all_category_services.dart';
// import '../../Controlller/get_category_with_featured.dart';
// import '../../Controlller/home_controller.dart';
// import '../../Models/all_category_services.dart'; // Import Category model
// import 'ac_service_details/category_detail_screen.dart';
// import 'most_booked_services.dart';
//
// class HomeServicesScreen extends StatefulWidget {
//   const HomeServicesScreen({super.key});
//
//   @override
//   State<HomeServicesScreen> createState() => _HomeServicesScreenState();
// }
//
// class _HomeServicesScreenState extends State<HomeServicesScreen> {
//   final TextEditingController searchController = TextEditingController();
//   final HomeController homeController = Get.put(HomeController());
//   final CategoriesWithFeaturedController categoriesWithFeaturedController = Get.put(CategoriesWithFeaturedController());
//   final AllHomeServicesCategoryController controller = Get.put(AllHomeServicesCategoryController());
//   int _selectedIndexCategory = -1; // For categoriesWithFeaturedController.categories
//   int _selectedIndexFeatured = -1; // For homeController.featuredCategories
//
//   void _navigateTo(BuildContext context, dynamic category, int index, bool isFeatured) {
//     // Convert Categories (from CategoriesWithFeaturedController) or FeaturedCategories to Category
//     final Category targetCategory = isFeatured
//         ? Category(
//       id: category.id,
//       categoryName: category.categoryName ?? 'Unknown',
//     )
//         : Category(
//       id: category.id,
//       categoryName: category.categoryName ?? 'Unknown',
//     );
//
//     debugPrint(
//       'HomeServicesScreen: Navigating to CategoryDetailsScreen for category=${targetCategory.categoryName}, index=$index, isFeatured=$isFeatured',
//     );
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CategoryDetailsScreen(
//           category: targetCategory,
//           services: controller.services.where((s) => s.category?.id == targetCategory.id).toList(),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     debugPrint('HomeServicesScreen: Disposed searchController');
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColors.whiteTheme,
//       body: Padding(
//         padding: EdgeInsets.only(top: height * 0.02),
//         child: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               title: CustomText(
//                 text: "Home Services",
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.darkBlueShade,
//               ),
//               floating: true,
//               pinned: true,
//               backgroundColor: AppColors.whiteTheme,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back, color: AppColors.darkBlueShade),
//                 onPressed: () {
//                   debugPrint('HomeServicesScreen: Back button tapped');
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             SliverPersistentHeader(pinned: true, floating: false, delegate: _SearchBarDelegate(searchController)),
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 SizedBox(height: height * 0.024),
//                 Obx(() {
//                   if (controller.isLoading.value ||
//                       homeController.isLoading.value ||
//                       categoriesWithFeaturedController.isLoading.value) {
//                     debugPrint('HomeServicesScreen: Showing loading indicator');
//                     return Center(child: CircularProgressIndicator(color: AppColors.darkBlueShade));
//                   }
//                   if (controller.errorMessage.isNotEmpty &&
//                       controller.services.isEmpty &&
//                       categoriesWithFeaturedController.model.value.data?.categories?.isEmpty == true &&
//                       homeController.homeModel.value.data?.featuredCategories?.isEmpty == true) {
//                     debugPrint('HomeServicesScreen: Showing error: ${controller.errorMessage.value}');
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CustomText(text: controller.errorMessage.value, fontSize: 16, color: Colors.red),
//                           SizedBox(height: height * 0.02),
//                           ElevatedButton(
//                             onPressed: () {
//                               debugPrint('HomeServicesScreen: Retry button tapped');
//                               controller.fetchCategories();
//                               homeController.fetchHomeData();
//                               categoriesWithFeaturedController.fetchCategoriesWithFeatured();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.darkBlueShade,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             ),
//                             child: const CustomText(
//                               text: 'Retry',
//                               fontSize: 16,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * 0.04),
//                         child: CustomText(
//                           text: 'Featured Services',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.darkBlueShade,
//                         ),
//                       ),
//                       ServiceList(),
//                       SizedBox(height: height * 0.024),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * 0.04),
//                         child: CustomText(
//                           text: 'All Services',
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.darkBlueShade,
//                         ),
//                       ),
//                       SizedBox(height: height * 0.01),
//                       Obx(() {
//                         final categories = categoriesWithFeaturedController.model.value.data?.categories ?? [];
//                         if (categories.isEmpty) {
//                           return Padding(
//                             padding: EdgeInsets.all(width * 0.04),
//                             child: CustomText(
//                               text: 'No categories available from CategoriesWithFeaturedController.',
//                               fontSize: 16,
//                               color: AppColors.hintGrey,
//                             ),
//                           );
//                         }
//                         return Padding(
//                           padding: EdgeInsets.all(width * 0.04),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               childAspectRatio: 0.9,
//                               crossAxisSpacing: width * 0.03,
//                               mainAxisSpacing: height * 0.02,
//                             ),
//                             itemCount: categories.length,
//                             itemBuilder: (context, index) {
//                               final category = categories[index];
//                               bool isSelected = _selectedIndexCategory == index;
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     _selectedIndexCategory = index;
//                                     _selectedIndexFeatured = -1; // Reset other grid's selection
//                                   });
//                                   _navigateTo(context, category, index, false);
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: isSelected ? AppColors.appColor : AppColors.whiteTheme,
//                                     borderRadius: BorderRadius.circular(12),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.2),
//                                         spreadRadius: 2,
//                                         blurRadius: 5,
//                                         offset: const Offset(0, 3),
//                                       ),
//                                     ],
//                                     gradient: isSelected
//                                         ? LinearGradient(
//                                       colors: [AppColors.appColor, AppColors.darkBlueShade],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     )
//                                         : null,
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       category.image != null && category.image!.isNotEmpty
//                                           ? Image.network(
//                                         category.image!,
//                                         height: height * 0.045,
//                                         width: height * 0.045,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (context, error, stackTrace) => Icon(
//                                           Icons.broken_image,
//                                           color: isSelected ? Colors.white : AppColors.appColor,
//                                           size: height * 0.045,
//                                         ),
//                                       )
//                                           : Icon(
//                                         Icons.image_not_supported,
//                                         color: isSelected ? Colors.white : AppColors.appColor,
//                                         size: height * 0.045,
//                                       ),
//                                       SizedBox(height: height * 0.010),
//                                       CustomText(
//                                         text: category.categoryName ?? 'Unknown',
//                                         fontSize: 14,
//                                         color: isSelected ? Colors.white : AppColors.appColor,
//                                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                       }),
//                       // SizedBox(height: height * 0.01),
//                       //
//                       // SizedBox(height: height * 0.01),
//                       //
//                       // SizedBox(height: height * 0.03),
//                     ],
//                   );
//                 }),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
//   final TextEditingController controller;
//
//   _SearchBarDelegate(this.controller);
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     double width = MediaQuery.of(context).size.width;
//
//     return Container(
//       color: AppColors.whiteTheme,
//       padding: EdgeInsets.all(width * 0.03),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: TextInputType.text,
//         onChanged: (value) {
//           debugPrint('HomeServicesScreen: Search query changed: $value');
//           // Implement search logic if needed
//         },
//         decoration: InputDecoration(
//           fillColor: Colors.grey.shade300,
//           filled: true,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: AppColors.darkBlueShade, width: 2),
//           ),
//           enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//           hintText: "Search services...",
//           hintStyle: TextStyle(color: Colors.grey.shade500),
//           prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
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




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/widgets/custom_text.dart';
import '../../../constants/app_colors.dart';
import '../../Controlller/all_category_services.dart';
import '../../Controlller/get_category_with_featured.dart';
import '../../Controlller/home_controller.dart';
import '../../Models/all_category_services.dart' as all_category; // Import Category model with alias
import '../../Models/get_categories_with_featured.dart';
import 'category_details_screen/category_detail_screen.dart';
import 'most_booked_services.dart';

class HomeServicesScreen extends StatefulWidget {
  const HomeServicesScreen({super.key});

  @override
  State<HomeServicesScreen> createState() => _HomeServicesScreenState();
}

class _HomeServicesScreenState extends State<HomeServicesScreen> {
  final TextEditingController searchController = TextEditingController();
  final HomeController homeController = Get.put(HomeController());
  // final CategoriesWithFeaturedController categoriesWithFeaturedController = Get.put(CategoriesWithFeaturedController());

  final CategoriesWithFeaturedController categoriesWithFeaturedController = Get.put(CategoriesWithFeaturedController());
  final AllHomeServicesCategoryController controller = Get.put(AllHomeServicesCategoryController());
  int _selectedIndexCategory = -1; // For categoriesWithFeaturedController.categories
  int _selectedIndexFeatured = -1; // For homeController.featuredCategories

  void _navigateTo(BuildContext context, dynamic category, int index, bool isFeatured) {
    // Convert Categories or FeaturedCategories to all_category.Category
    final all_category.Category targetCategory = all_category.Category(
      id: category.id,
      categoryName: category.categoryName ?? 'Unknown',
    );

    // Convert FeaturedServices to all_category.Services
    final categoryServices = categoriesWithFeaturedController.model.value.data?.featuredServices
        ?.where((s) => s.category?.id == category.id)
        .map((s) => all_category.Services(
      id: s.id,
      serviceName: s.serviceName,
      description: s.description,
      regularPrice: s.regularPrice,
      salePrice: s.salePrice?.toString(),
      image: s.image,
      isFeatured: s.isFeatured,
      category: s.category != null
          ? all_category.Category(
        id: s.category!.id,
        categoryName: s.category!.categoryName ?? 'Unknown',
      )
          : null,
    ))
        .toList() ??
        [];

    debugPrint(
      'HomeServicesScreen: Navigating to CategoryDetailsScreen for category=${targetCategory.categoryName}, index=$index, isFeatured=$isFeatured, services=${categoryServices.length}',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(
          category: targetCategory,
          services: categoryServices,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    debugPrint('HomeServicesScreen: Disposed searchController');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      body: Padding(
        padding: EdgeInsets.only(top: height * 0.02),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: CustomText(
                text: "Home Services",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlueShade,
              ),
              floating: true,
              pinned: true,
              backgroundColor: AppColors.whiteTheme,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.darkBlueShade),
                onPressed: () {
                  debugPrint('HomeServicesScreen: Back button tapped');
                  Navigator.pop(context);
                },
              ),
            ),
            SliverPersistentHeader(pinned: true, floating: false, delegate: _SearchBarDelegate(searchController)),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: height * 0.024),
                Obx(() {
                  if (controller.isLoading.value ||
                      homeController.isLoading.value ||
                      categoriesWithFeaturedController.isLoading.value) {
                    debugPrint('HomeServicesScreen: Showing loading indicator');
                    return Center(child: CircularProgressIndicator(color: AppColors.darkBlueShade));
                  }
                  if (controller.errorMessage.isNotEmpty &&
                      controller.services.isEmpty &&
                      categoriesWithFeaturedController.model.value.data?.categories?.isEmpty == true &&
                      homeController.homeModel.value.data?.featuredCategories?.isEmpty == true) {
                    debugPrint('HomeServicesScreen: Showing error: ${controller.errorMessage.value}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(text: controller.errorMessage.value, fontSize: 16, color: Colors.red),
                          SizedBox(height: height * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('HomeServicesScreen: Retry button tapped');
                              controller.fetchCategories();
                              homeController.fetchHomeData();
                              categoriesWithFeaturedController.fetchCategoriesWithFeatured();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkBlueShade,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const CustomText(
                              text: 'Retry',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: CustomText(
                          text: 'Featured Services',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlueShade,
                        ),
                      ),
                      ServiceList(),
                      SizedBox(height: height * 0.024),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: CustomText(
                          text: 'All Services',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlueShade,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Obx(() {
                        final categories = categoriesWithFeaturedController.model.value.data?.categories ?? [];
                        if (categories.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(width * 0.04),
                            child: CustomText(
                              text: 'No categories available from CategoriesWithFeaturedController.',
                              fontSize: 16,
                              color: AppColors.hintGrey,
                            ),
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.all(width * 0.04),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: width * 0.03,
                              mainAxisSpacing: height * 0.02,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              bool isSelected = _selectedIndexCategory == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndexCategory = index;
                                    _selectedIndexFeatured = -1; // Reset other grid's selection
                                  });
                                  _navigateTo(context, category, index, false);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.appColor : AppColors.whiteTheme,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    gradient: isSelected
                                        ? LinearGradient(
                                      colors: [AppColors.appColor, AppColors.darkBlueShade],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                        : null,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      category.image != null && category.image!.isNotEmpty
                                          ? Image.network(
                                        category.image!,
                                        height: height * 0.045,
                                        width: height * 0.045,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.broken_image,
                                          color: isSelected ? Colors.white : AppColors.appColor,
                                          size: height * 0.045,
                                        ),
                                      )
                                          : Icon(
                                        Icons.image_not_supported,
                                        color: isSelected ? Colors.white : AppColors.appColor,
                                        size: height * 0.045,
                                      ),
                                      SizedBox(height: height * 0.010),
                                      CustomText(
                                        text: category.categoryName ?? 'Unknown',
                                        fontSize: 14,
                                        color: isSelected ? Colors.white : AppColors.appColor,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      SizedBox(height: height * 0.01),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      //   child: CustomText(
                      //     text: 'Featured Categories',
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.darkBlueShade,
                      //   ),
                      // ),
                      SizedBox(height: height * 0.01),
                      // Obx(() {
                      //   if (homeController.isLoading.value) {
                      //     return const Center(child: CircularProgressIndicator());
                      //   }
                      //   final categories = homeController.homeModel.value.data?.featuredCategories ?? [];
                      //   if (categories.isEmpty) {
                      //     return Padding(
                      //       padding: EdgeInsets.all(width * 0.04),
                      //       child: CustomText(
                      //         text: 'No featured categories available.',
                      //         fontSize: 16,
                      //         color: AppColors.hintGrey,
                      //       ),
                      //     );
                      //   }
                      //   return Padding(
                      //     padding: EdgeInsets.all(width * 0.04),
                      //     child: GridView.builder(
                      //       shrinkWrap: true,
                      //       physics: const NeverScrollableScrollPhysics(),
                      //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 3,
                      //         childAspectRatio: 0.9,
                      //         crossAxisSpacing: 10,
                      //         mainAxisSpacing: 10,
                      //       ),
                      //       itemCount: categories.length,
                      //       itemBuilder: (context, index) {
                      //         final category = categories[index];
                      //         bool isSelected = _selectedIndexFeatured == index;
                      //         return GestureDetector(
                      //           onTap: () {
                      //             setState(() {
                      //               _selectedIndexFeatured = index;
                      //               _selectedIndexCategory = -1; // Reset other grid's selection
                      //             });
                      //             _navigateTo(context, category, index, true);
                      //           },
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               color: isSelected ? AppColors.appColor : AppColors.whiteTheme,
                      //               borderRadius: BorderRadius.circular(12),
                      //               gradient: isSelected
                      //                   ? LinearGradient(
                      //                 colors: [AppColors.appColor, AppColors.darkBlueShade],
                      //                 begin: Alignment.topLeft,
                      //                 end: Alignment.bottomRight,
                      //               )
                      //                   : null,
                      //             ),
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 category.image != null
                      //                     ? Image.network(
                      //                   category.image!,
                      //                   height: height * 0.045,
                      //                   width: height * 0.045,
                      //                   fit: BoxFit.contain,
                      //                   errorBuilder: (context, error, stackTrace) => Icon(
                      //                     Icons.broken_image,
                      //                     color: isSelected ? Colors.white : AppColors.appColor,
                      //                     size: height * 0.045,
                      //                   ),
                      //                 )
                      //                     : Icon(
                      //                   Icons.image,
                      //                   color: isSelected ? Colors.white : AppColors.appColor,
                      //                   size: height * 0.045,
                      //                 ),
                      //                 SizedBox(height: height * 0.010),
                      //                 CustomText(
                      //                   text: category.categoryName ?? "No Name",
                      //                   fontSize: 14,
                      //                   color: isSelected ? Colors.white : AppColors.appColor,
                      //                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   );
                      // }),
                      SizedBox(height: height * 0.03),
                    ],
                  );
                }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  _SearchBarDelegate(this.controller);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.whiteTheme,
      padding: EdgeInsets.all(width * 0.03),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          debugPrint('HomeServicesScreen: Search query changed: $value');
          // Implement search logic if needed
        },
        decoration: InputDecoration(
          fillColor: Colors.grey.shade300,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.darkBlueShade, width: 2),
          ),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          hintText: "Search services...",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}