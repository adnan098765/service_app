import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/Controlller/all_category_services.dart';
import 'package:untitled2/Controlller/home_controller.dart';
import 'package:untitled2/models/home_model.dart';

import '../Models/all_category_services.dart';
import 'ViewAllServices/AcServiceDetails/category_detail_screen.dart';

class CategoriesGrid extends StatefulWidget {
  const CategoriesGrid({super.key});

  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  final HomeController homeController = Get.put(HomeController());
  final AllHomeServicesCategoryController servicesController = Get.put(AllHomeServicesCategoryController());
  int? _selectedIndex;

  void _navigate(BuildContext context, int index) {
    final category = homeController.homeModel.value.data?.featuredCategories?[index];
    if (category == null) {
      debugPrint("CategoriesGrid: No category found at index $index");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(
          category: Category(
            id: category.id,
            categoryName: category.categoryName,
            image: category.image,
          ),
          services: servicesController.services
              .where((s) => s.category?.id == category.id)
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = homeController.homeModel.value.data?.featuredCategories ?? [];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            bool isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                _navigate(context, index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.appColor : AppColors.whiteTheme,
                  borderRadius: BorderRadius.circular(12),
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
                    category.image != null
                        ? Image.network(
                      category.image!,
                      height: height * 0.045,
                      width: height * 0.045,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        color: isSelected ? Colors.white : AppColors.appColor,
                        size: height * 0.045,
                      ),
                    )
                        : Icon(
                      Icons.image,
                      color: isSelected ? Colors.white : AppColors.appColor,
                      size: height * 0.045,
                    ),
                    SizedBox(height: height * 0.010),
                    Text(
                      category.categoryName ?? "No Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.appColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}