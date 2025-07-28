import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';
import '../../Controlller/all_category_services.dart';
import '../../Models/all_category_services.dart';
import 'AcServiceDetails/category_detail_screen.dart';
import 'most_booked_services.dart';

class HomeServicesScreen extends StatefulWidget {
  const HomeServicesScreen({super.key});

  @override
  State<HomeServicesScreen> createState() => _HomeServicesScreenState();
}

class _HomeServicesScreenState extends State<HomeServicesScreen> {
  final TextEditingController searchController = TextEditingController();
  final AllHomeServicesCategoryController controller = Get.put(AllHomeServicesCategoryController());
  int _selectedIndex = -1;

  void _navigateTo(BuildContext context, int index) {
    final category = controller.categories[index];
    debugPrint(
        'HomeServicesScreen: Navigating to CategoryDetailsScreen for category=${category.categoryName}, index=$index');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(
          category: category,
          services: controller.services
              .where((s) => s.category?.id == category.id)
              .toList(),
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
              title:  CustomText(
                text: "Home Services",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlueShade,
              ),
              floating: true,
              pinned: true,
              backgroundColor: AppColors.whiteTheme,
              leading: IconButton(
                icon:  Icon(Icons.arrow_back, color: AppColors.darkBlueShade),
                onPressed: () {
                  debugPrint('HomeServicesScreen: Back button tapped');
                  Navigator.pop(context);
                },
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SearchBarDelegate(searchController),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: height * 0.024),
                Obx(() {
                  if (controller.isLoading.value) {
                    debugPrint('HomeServicesScreen: Showing loading indicator');
                    return  Center(child: CircularProgressIndicator(color: AppColors.darkBlueShade));
                  }
                  if (controller.errorMessage.isNotEmpty && controller.services.isEmpty && controller.categories.isEmpty) {
                    debugPrint('HomeServicesScreen: Showing error: ${controller.errorMessage.value}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: controller.errorMessage.value,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          SizedBox(height: height * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              debugPrint('HomeServicesScreen: Retry button tapped');
                              controller.fetchCategories();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkBlueShade,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                      // const MostBookedServices(),
                      SizedBox(height: height * 0.024),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child:  CustomText(
                          text: 'All Services',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkBlueShade,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      if (controller.categories.isNotEmpty)
                        Padding(
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
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              final category = controller.categories[index];
                              bool isSelected = _selectedIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                  _navigateTo(context, index);
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
                                      Icon(
                                        controller.getCategoryIcon(category.categoryName),
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
                                        // maxLines: 2,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (controller.categories.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(width * 0.04),
                          child:  CustomText(
                            text: 'No categories available, but services may be listed above.',
                            fontSize: 16,
                            color: AppColors.hintGrey,
                          ),
                        ),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  BorderSide(color: AppColors.darkBlueShade, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
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