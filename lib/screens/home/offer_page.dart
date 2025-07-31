import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/widgets/custom_text.dart';

import '../../constants/app_colors.dart';
import '../Controlller/banner_controller.dart';

class OfferBanner extends StatelessWidget {
  const OfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final FeaturedBannerController controller = Get.put(FeaturedBannerController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            height: 120,
            decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(10)),
            child: Center(child: CircularProgressIndicator(color: AppColors.whiteTheme)),
          );
        } else if (controller.errorMessage.value.isNotEmpty) {
          return Container(
            height: 120,
            decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: CustomText(text: controller.errorMessage.value, color: AppColors.whiteTheme, fontSize: 16),
            ),
          );
        } else if (controller.featuredBanners.isEmpty) {
          return Container(
            height: 120,
            decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(10)),
            child: Center(child: CustomText(text: 'No banners available', color: AppColors.whiteTheme, fontSize: 16)),
          );
        }

        final banner = controller.featuredBanners.first; // Access Data object
        return Container(
          decoration: BoxDecoration(color: AppColors.appColor, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: banner.name ?? 'Special Offer', // Use Data's name
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteTheme,
                    ),
                    CustomText(text: 'Check out our latest promotion', color: AppColors.blueShade, fontSize: 15),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle navigation or action (e.g., to link_url if provided)
                        if (banner.linkUrl != null) {
                          // Implement navigation logic here (e.g., Get.toNamed(banner.linkUrl))
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueShade,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: CustomText(
                        text: 'BOOK NOW',
                        color: AppColors.whiteTheme,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                'https://app.techbees.co${banner.imageUrl}', // Use Data's imageUrl
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/img.png', height: 100); // Fallback image
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
