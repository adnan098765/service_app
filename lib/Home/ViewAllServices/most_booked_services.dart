import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import '../../Controlller/get_category_with_featured.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoriesWithFeaturedController controller =
    Get.put(CategoriesWithFeaturedController());

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
                  title: service.serviceName ?? '',
                  description: service.description ?? '',
                  originalPrice: service.salePrice != null
                      ? 'Rs. ${service.regularPrice ?? ''}'
                      : '',
                  discountedPrice: 'Rs. ${service.regularPrice ?? ''}',
                  imageUrl: service.image ?? '',
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
  final String title;
  final String description;
  final String originalPrice;
  final String discountedPrice;
  final String imageUrl;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.140,
      width: width * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: height * 0.110,
            width: width * 0.250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: width * 0.020),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
                Row(
                  children: [
                    if (originalPrice.isNotEmpty)
                      Text(
                        originalPrice,
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    SizedBox(width: width * 0.015),
                    Text(
                      discountedPrice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
