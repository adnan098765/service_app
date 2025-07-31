import 'package:get/get.dart';

import '../Models/featured_banner_model.dart';

class FeaturedBannerController extends GetxController {
  var isLoading = true.obs;
  var featuredBanners = <Data>[].obs; // Changed to List<Data>
  var errorMessage = ''.obs;

  Future<FeaturedBannerModel> fetchBanners() async {
    try {
      isLoading.value = true;
      // Simulate API call with the provided JSON response
      final jsonResponse = {
        "success": true,
        "data": [
          {
            "id": 1,
            "name": "promo1",
            "title": null,
            "description": null,
            "image_url": "/storage/banners/audxLw2XF2YrFxDrDxuxwnsRDnbiaaKhoQiMD6SG.jpg",
            "link_url": null,
            "sort_order": 0,
          },
        ],
      };

      final bannerModel = FeaturedBannerModel.fromJson(jsonResponse);
      if (bannerModel.success == true && bannerModel.data != null) {
        featuredBanners.assignAll(bannerModel.data!);
      } else {
        errorMessage.value = 'Failed to load banners';
      }
      return bannerModel; // Return the parsed model
    } catch (e) {
      errorMessage.value = 'Error fetching banners: $e';
      return FeaturedBannerModel(success: false, data: null); // Return with error state
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }
}
