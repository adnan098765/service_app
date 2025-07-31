import 'package:get/get.dart';
import 'package:dio/dio.dart' as DioResponse;

class AuthenticationController extends GetxController {
  var phoneNumber = ''.obs;
  var fullName = ''.obs;
  var email = ''.obs;
  var selectedGender = 'Male'.obs;
  var isLoading = false.obs;

  final DioResponse.Dio _dio = DioResponse.Dio();

  Future<void> sendOtp() async {
    if (phoneNumber.value.isEmpty) {
      Get.snackbar("Error", "Phone number is required");
      return;
    }

    try {
      isLoading.value = true;

      DioResponse.Response response = await _dio.post(
        "https://yourapi.com/send-otp",
        data: {
          "phone": phoneNumber.value,
          "full_name": fullName.value.isNotEmpty ? fullName.value : null,
          "email": email.value.isNotEmpty ? email.value : null,
          "gender": selectedGender.value,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        Get.toNamed('/otp', arguments: phoneNumber.value);
      } else {
        Get.snackbar("Error", response.data['message'] ?? "Failed to send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
