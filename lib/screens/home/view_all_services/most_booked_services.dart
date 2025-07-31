import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../Controlller/get_category_with_featured.dart';
import '../../Controlller/add_address_controller.dart';
import '../../Models/all_category_services.dart' as all_category;
import '../../Models/get_categories_with_featured.dart';
import 'category_details_screen/category_detail_screen.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoriesWithFeaturedController controller = Get.put(CategoriesWithFeaturedController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final services = controller.model.value.data?.featuredServices ?? [];

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: services.map((service) {
            return Row(
              children: [
                const SizedBox(width: 10),
                ServiceCard(
                  service: service,
                ),
              ],
            );
          }).toList(),
        ),
      );
    });
  }
}

class ServiceCard extends StatelessWidget {
  final FeaturedServices service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final controller = Get.find<CategoriesWithFeaturedController>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        try {
          debugPrint('ServiceCard: Tap detected for service=${service.serviceName}, category=${service.category?.categoryName}');
          if (service.category == null) {
            Get.snackbar(
              'Error',
              'No category associated with this service',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          // Convert Category to all_category.Category
          final allCategory = all_category.Category(
            id: service.category!.id,
            categoryName: service.category!.categoryName ?? 'Unknown',
          );

          // Convert FeaturedServices to all_category.Services
          final categoryServices = controller.model.value.data?.featuredServices
              ?.where((s) => s.category?.id == service.category!.id)
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

          debugPrint('ServiceCard: Navigating to CategoryDetailsScreen with ${categoryServices.length} services');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailsScreen(
                category: allCategory,
                services: categoryServices,
                regularPrice: service.regularPrice,
                salePrice: service.salePrice,
              ),
            ),
          ).then((_) {
            debugPrint('ServiceCard: Returned from CategoryDetailsScreen');
          }).catchError((error) {
            debugPrint('ServiceCard: Navigation error: $error');
            Get.snackbar(
              'Navigation Error',
              'Failed to navigate: $error',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          });
        } catch (e, stackTrace) {
          debugPrint('ServiceCard: Error during navigation: $e');
          debugPrint('ServiceCard: Stack trace: $stackTrace');
          Get.snackbar(
            'Navigation Error',
            'Failed to navigate: $e',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Container(
        height: height * 0.140,
        width: width * 0.85,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              height: height * 0.110,
              width: width * 0.250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: service.image != null && service.image!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(service.image!),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => const Icon(Icons.broken_image),
                )
                    : null,
              ),
              child: service.image == null || service.image!.isEmpty
                  ? const Icon(Icons.image_not_supported, color: Colors.white70)
                  : null,
            ),
            SizedBox(width: width * 0.020),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceName ?? 'Unknown',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    service.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Row(
                    children: [
                      if (service.salePrice?.isNotEmpty ?? false)
                        Text(
                          'Rs. ${service.regularPrice ?? '0'}',
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      SizedBox(width: width * 0.015),
                      Text(
                        'Rs. ${service.salePrice?.isNotEmpty ?? false ? service.salePrice : service.regularPrice ?? '0'}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}