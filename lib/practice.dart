// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../Auth/otp_screen.dart';
// import '../Models/user_created_model.dart';
// import '../constants/app_urls.dart';
// import '../models/send_otp_model.dart';
//
// class PhoneNumberController extends GetxController {
//   final TextEditingController phoneNumberController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   var isPhoneValid = false.obs;
//   var isLoading = false.obs;
//
//   @override
//   void onClose() {
//     debugPrint("PhoneNumberController disposed");
//     phoneNumberController.dispose();
//     super.onClose();
//   }
//
//   void onPhoneChanged(String value) {
//     // Pakistan mobile numbers validation - should start with 3 and be 10 digits
//     isPhoneValid.value = value.length == 10 && value.startsWith('3');
//     debugPrint("Phone changed: $value | Valid: ${isPhoneValid.value}");
//   }
//
//   String _formatPhoneNumber(String phone) {
//     // Ensure proper formatting for Pakistan numbers
//     String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
//
//     // If it's 10 digits and starts with 3, add +92
//     if (cleanPhone.length == 10 && cleanPhone.startsWith('3')) {
//       return '+92$cleanPhone';
//     }
//
//     // If it's 11 digits and starts with 03, replace 0 with +92
//     if (cleanPhone.length == 11 && cleanPhone.startsWith('03')) {
//       return '+92${cleanPhone.substring(1)}';
//     }
//
//     // If it already has country code
//     if (cleanPhone.startsWith('92') && cleanPhone.length == 12) {
//       return '+$cleanPhone';
//     }
//
//     return '+92$cleanPhone';
//   }
//
//   Future<void> verifyPhoneNumber(BuildContext context) async {
//     if (!formKey.currentState!.validate()) {
//       debugPrint("Phone form not valid");
//       return;
//     }
//
//     isLoading.value = true;
//     final fullPhone = _formatPhoneNumber(phoneNumberController.text.trim());
//     debugPrint("Starting phone verification for: $fullPhone");
//
//     try {
//       final checkUserResponse = await http.post(
//         Uri.parse(AppUrls.userCreated),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({'mobile': fullPhone}),
//       );
//
//       debugPrint('Check User API Response: ${checkUserResponse.statusCode} | ${checkUserResponse.body}');
//
//       if (checkUserResponse.statusCode == 200) {
//         final createUserModel = CreateUserModel.fromJson(jsonDecode(checkUserResponse.body));
//
//         if (createUserModel.success == true) {
//           debugPrint("User check passed. Sending OTP to: $fullPhone");
//
//           // Add delay before sending OTP to avoid rate limiting
//           await Future.delayed(const Duration(milliseconds: 500));
//
//           final otpResponse = await http.post(
//             Uri.parse(AppUrls.sendOtp),
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//             body: jsonEncode({
//               'mobile': fullPhone,
//               'country_code': '+92', // Explicitly add country code
//               'message_type': 'sms', // Specify SMS type
//             }),
//           );
//
//           debugPrint('Send OTP API Response: ${otpResponse.statusCode} | ${otpResponse.body}');
//
//           if (otpResponse.statusCode == 200) {
//             final sendOtpModel = SendOtpModel.fromJson(jsonDecode(otpResponse.body));
//             debugPrint("Parsed OTP from response: ${sendOtpModel.oTP}");
//             debugPrint("SMS Status: ${sendOtpModel.smsData}");
//
//             if (sendOtpModel.success == true) {
//               // Check SMS status safely
//               if (sendOtpModel.smsData != null) {
//                 bool smsStatus = false;
//                 if (sendOtpModel.smsData is Map<String, dynamic>) {
//                   final smsDataMap = sendOtpModel.smsData as Map<String, dynamic>;
//                   smsStatus = smsDataMap['success'] == true;
//                 }
//
//                 if (smsStatus) {
//                   Get.snackbar(
//                     'Success',
//                     'OTP sent successfully to $fullPhone',
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.green,
//                     colorText: Colors.white,
//                     duration: const Duration(seconds: 4),
//                   );
//                 } else {
//                   Get.snackbar(
//                     'Warning',
//                     'OTP generated but SMS delivery pending. Please check your phone.',
//                     snackPosition: SnackPosition.TOP,
//                     backgroundColor: Colors.orange,
//                     colorText: Colors.white,
//                     duration: const Duration(seconds: 5),
//                   );
//                 }
//               } else {
//                 // If smsData is null, show generic success message
//                 Get.snackbar(
//                   'Success',
//                   'OTP sent successfully to $fullPhone',
//                   snackPosition: SnackPosition.TOP,
//                   backgroundColor: Colors.green,
//                   colorText: Colors.white,
//                   duration: const Duration(seconds: 4),
//                 );
//               }
//
//               debugPrint("OTP sent successfully. Navigating to OTP screen.");
//
//               Get.to(() => OtpScreen(
//                 phoneNumber: phoneNumberController.text,
//                 customerId: createUserModel.customerId ?? 0,
//                 actualOtp: sendOtpModel.oTP, // Pass the actual OTP for testing
//                 // token: createUserModel.token, // Uncomment this
//               ));
//             } else {
//               debugPrint("OTP sending failed: ${sendOtpModel.message}");
//               Get.snackbar(
//                 'Error',
//                 sendOtpModel.message ?? 'Failed to send OTP',
//                 snackPosition: SnackPosition.TOP,
//                 backgroundColor: Colors.red,
//                 colorText: Colors.white,
//               );
//             }
//           } else {
//             debugPrint("Send OTP API Error: ${otpResponse.statusCode}");
//             _handleApiError(otpResponse);
//           }
//         } else {
//           debugPrint("User creation failed: ${createUserModel.message}");
//           Get.snackbar(
//             'Error',
//             createUserModel.message ?? 'Failed to create/check user',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.red,
//             colorText: Colors.white,
//           );
//         }
//       } else {
//         debugPrint("Check User API error: ${checkUserResponse.statusCode}");
//         _handleApiError(checkUserResponse);
//       }
//     } catch (e) {
//       debugPrint("Exception during OTP flow: $e");
//       Get.snackbar(
//         'Error',
//         'Network error: Please check your internet connection',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//       debugPrint("Phone verification flow ended");
//     }
//   }
//
//   void _handleApiError(http.Response response) {
//     String errorMessage = 'Server error occurred';
//
//     try {
//       final errorData = jsonDecode(response.body);
//       errorMessage = errorData['message'] ?? errorMessage;
//     } catch (e) {
//       // If JSON parsing fails, use default message
//     }
//
//     Get.snackbar(
//       'Error',
//       '$errorMessage (Code: ${response.statusCode})',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../Auth/authentication_screen.dart';
// import '../constants/app_urls.dart';
// import '../models/send_otp_model.dart';
//
// class OtpController extends GetxController {
//   final TextEditingController otpController = TextEditingController();
//   var secondsRemaining = 30.obs;
//   var isResendEnabled = false.obs;
//   var isLoading = false.obs;
//   Timer? _timer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     debugPrint("OtpController initialized");
//     startTimer();
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     otpController.dispose();
//     debugPrint("OtpController disposed");
//     super.onClose();
//   }
//
//   void startTimer() {
//     secondsRemaining.value = 30;
//     isResendEnabled.value = false;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (secondsRemaining.value > 0) {
//         secondsRemaining.value--;
//       } else {
//         timer.cancel();
//         isResendEnabled.value = true;
//       }
//     });
//     debugPrint("OTP timer started");
//   }
//
//   Future<void> resendOtp(String phoneNumber) async {
//     if (!isResendEnabled.value) {
//       debugPrint("Resend OTP called too soon");
//       return;
//     }
//
//     isLoading.value = true;
//     try {
//       debugPrint("Sending OTP to +92$phoneNumber");
//       final response = await http.post(
//         Uri.parse(AppUrls.sendOtp),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'mobile': '+92$phoneNumber'}),
//       );
//
//       debugPrint('Resend OTP Response: ${response.statusCode} - ${response.body}');
//
//       if (response.statusCode == 200) {
//         final sendOtpModel = SendOtpModel.fromJson(jsonDecode(response.body));
//         if (sendOtpModel.success == true) {
//           Get.snackbar('Success', 'New OTP sent successfully',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//               colorText: Colors.white);
//           startTimer();
//         } else {
//           Get.snackbar('Error', sendOtpModel.message ?? 'Failed to resend OTP',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//               colorText: Colors.white);
//         }
//       } else {
//         Get.snackbar('Error',
//             'Server error occurred while resending OTP: Status ${response.statusCode}',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.red,
//             colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint('Exception during resend OTP: $e');
//       Get.snackbar('Error', 'Something went wrong: $e',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> verifyOtp(String phoneNumber, int customerId, String? token) async {
//     if (otpController.text.length != 4) {
//       Get.snackbar('Invalid Input', 'Please enter a 4-digit OTP',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       return;
//     }
//
//     isLoading.value = true;
//     try {
//       debugPrint("Verifying OTP: ${otpController.text} for +92$phoneNumber");
//
//       // THIS IS THE KEY FIX - Use the correct verification endpoint
//       final response = await http.post(
//         Uri.parse(AppUrls.sendOtp), // Use a separate verify endpoint
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'mobile': '+92$phoneNumber',
//           'otp': otpController.text,
//           'customer_id': customerId, // Include customer ID if needed
//         }),
//       );
//
//       debugPrint('Verify OTP Response: ${response.statusCode} - ${response.body}');
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//
//         // Check if verification was successful
//         if (responseData['success'] == true) {
//           Get.snackbar('Success', '✅ OTP Verified Successfully',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//               colorText: Colors.white);
//
//           // Navigate to next screen
//           Get.off(() => AuthenticationScreen(
//             customerId: customerId,
//             token: token,
//           ));
//         } else {
//           Get.snackbar('Error', responseData['message'] ?? '❌ Invalid OTP',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//               colorText: Colors.white);
//         }
//       } else {
//         Get.snackbar('Error', '❌ OTP Verification Failed: Status ${response.statusCode}',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.red,
//             colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint('Exception during OTP verification: $e');
//       Get.snackbar('Error', 'Something went wrong: $e',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Alternative method if you don't have separate verify endpoint
//   Future<void> verifyOtpAlternative(String phoneNumber, int customerId, String? token, String? actualOtp) async {
//     if (otpController.text.length != 4) {
//       Get.snackbar('Invalid Input', 'Please enter a 4-digit OTP',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//       return;
//     }
//
//     isLoading.value = true;
//     try {
//       debugPrint("Verifying OTP: ${otpController.text} for +92$phoneNumber");
//
//       // If you have the actual OTP, verify locally first
//       if (actualOtp != null) {
//         if (otpController.text == actualOtp) {
//           Get.snackbar('Success', '✅ OTP Verified Successfully',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//               colorText: Colors.white);
//
//           Get.off(() => AuthenticationScreen(
//             customerId: customerId,
//             token: token,
//           ));
//           return;
//         } else {
//           Get.snackbar('Error', '❌ Invalid OTP',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//               colorText: Colors.white);
//           return;
//         }
//       }
//
//       // If no actual OTP available, call API with verification flag
//       final response = await http.post(
//         Uri.parse(AppUrls.sendOtp), // Same endpoint but with verification flag
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'mobile': '+92$phoneNumber',
//           'otp': otpController.text,
//           'action': 'verify', // Add action flag
//           'customer_id': customerId,
//         }),
//       );
//
//       debugPrint('Verify OTP Response: ${response.statusCode} - ${response.body}');
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//
//         if (responseData['success'] == true && responseData['verified'] == true) {
//           Get.snackbar('Success', '✅ OTP Verified Successfully',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//               colorText: Colors.white);
//
//           Get.off(() => AuthenticationScreen(
//             customerId: customerId,
//             token: token,
//           ));
//         } else {
//           Get.snackbar('Error', responseData['message'] ?? '❌ Invalid OTP',
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//               colorText: Colors.white);
//         }
//       } else {
//         Get.snackbar('Error', '❌ OTP Verification Failed: Status ${response.statusCode}',
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: Colors.red,
//             colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint('Exception during OTP verification: $e');
//       Get.snackbar('Error', 'Something went wrong: $e',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
// import 'package:untitled2/widgets/custom_text.dart';
// import '../Controlller/otp_controller.dart';
// import 'authentication_screen.dart';
//
// class OtpScreen extends StatelessWidget {
//   final String phoneNumber;
//   final int customerId;
//   final String? token;
//   final String? actualOtp;
//
//   const OtpScreen({
//     super.key,
//     required this.phoneNumber,
//     required this.customerId,
//     this.token,
//     this.actualOtp,
//   });
//
//   String _formatPhoneNumber(String phone) {
//     return phone.length == 10 ? '+92$phone' : phone;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('OtpScreen initialized with phoneNumber: $phoneNumber, customerId: $customerId, token: $token');
//     if (actualOtp != null) {
//       print('Actual OTP for testing: $actualOtp');
//     }
//
//     final OtpController controller = Get.put(OtpController());
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 60,
//       textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               CustomText(
//                 text: "OTP Verification",
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.appColor,
//               ),
//               const SizedBox(height: 10),
//               const CustomText(
//                 text: "We've sent a 4-digit verification code to",
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//               const SizedBox(height: 5),
//               CustomText(
//                 text: _formatPhoneNumber(phoneNumber),
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.appColor,
//               ),
//
//               // Show OTP for testing in debug mode
//               if (actualOtp != null) ...[
//                 const SizedBox(height: 10),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.blue.withOpacity(0.3)),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.info, color: Colors.blue, size: 20),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           'Test OTP: $actualOtp (SMS may take time to deliver)',
//                           style: const TextStyle(
//                             color: Colors.blue,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//
//               const SizedBox(height: 40),
//               Center(
//                 child: Pinput(
//                   length: 4,
//                   controller: controller.otpController,
//                   defaultPinTheme: defaultPinTheme,
//                   focusedPinTheme: defaultPinTheme.copyWith(
//                     decoration: defaultPinTheme.decoration!.copyWith(
//                       border: Border.all(color: AppColors.appColor),
//                     ),
//                   ),
//                   showCursor: true,
//                   onCompleted: (pin) {
//                     print('Entered OTP: $pin');
//                     // Use alternative verification if actualOtp is available
//                     if (actualOtp != null) {
//                       controller.verifyOtpAlternative(phoneNumber, customerId, token, actualOtp);
//                     } else {
//                       controller.verifyOtp(phoneNumber, customerId, token);
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // SMS Status Information
//               // Container(
//               //   padding: const EdgeInsets.all(12),
//               //   decoration: BoxDecoration(
//               //     color: Colors.grey.withOpacity(0.1),
//               //     borderRadius: BorderRadius.circular(8),
//               //   ),
//               //   child: Column(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     children: [
//               //       const Text(
//               //         'SMS Troubleshooting:',
//               //         style: TextStyle(
//               //           fontWeight: FontWeight.bold,
//               //           fontSize: 12,
//               //         ),
//               //       ),
//               //       const SizedBox(height: 4),
//               //       const Text(
//               //         '• Check your spam/junk messages\n'
//               //             '• Ensure good network coverage\n'
//               //             '• SMS may take 1-5 minutes to deliver\n'
//               //             '• Try resending if not received',
//               //         style: TextStyle(fontSize: 11, color: Colors.grey),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//
//               const SizedBox(height: 20),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Obx(() => TextButton(
//                   onPressed: controller.isResendEnabled.value
//                       ? () {
//                     print('Resending OTP for: $phoneNumber');
//                     controller.resendOtp(phoneNumber);
//                   }
//                       : null,
//                   child: Text(
//                     controller.isResendEnabled.value
//                         ? "Resend OTP"
//                         : "Resend in ${controller.secondsRemaining.value} s",
//                     style: TextStyle(
//                       color: controller.isResendEnabled.value
//                           ? AppColors.appColor
//                           : Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )),
//               ),
//               const SizedBox(height: 30),
//               Obx(() => SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.buttonColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () {
//                     print('Verify button pressed');
//                     // Use alternative verification if actualOtp is available
//                     if (actualOtp != null) {
//                       controller.verifyOtpAlternative(phoneNumber, customerId, token, actualOtp);
//                     } else {
//                       controller.verifyOtp(phoneNumber, customerId, token);
//                     }
//                   },
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const CustomText(
//                     text: "Verify",
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               )),
//               const SizedBox(height: 20),
//               // const Center(
//               //   child: Text(
//               //     "Didn't receive code? Check your spam folder",
//               //     style: TextStyle(color: Colors.grey, fontSize: 12),
//               //   ),
//               // ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
// import 'package:untitled2/widgets/custom_container.dart';
// import 'package:untitled2/widgets/custom_text.dart';
//
// import '../Controlller/phone_number_controller.dart';
//
// class EnterPhoneNumber extends StatelessWidget {
//   const EnterPhoneNumber({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final PhoneNumberController controller = Get.put(PhoneNumberController());
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: AppColors.whiteTheme,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: SafeArea(
//             child: Form(
//               key: controller.formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: height * 0.04),
//                   CustomText(
//                     text: "Welcome to our company",
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   CustomText(
//                     text: "Please enter your phone number to continue",
//                     fontSize: 16,
//                   ),
//                   SizedBox(height: height * 0.040),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: TextFormField(
//                       controller: controller.phoneNumberController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(10),
//                       ],
//                       onChanged: controller.onPhoneChanged,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter phone number';
//                         }
//                         if (value.length != 10) {
//                           return 'Enter valid 10-digit number';
//                         }
//                         return null;
//                       },
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                             color: AppColors.appColor,
//                             width: 1.5,
//                           ),
//                         ),
//                         hintText: "3XX XXXXXXX",
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                         prefixIcon: Padding(
//                           padding: const EdgeInsets.only(left: 10, right: 5),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Image.asset(
//                                 'assets/images/img_3.png',
//                                 width: 30,
//                                 height: 30,
//                               ),
//                               const SizedBox(width: 5),
//                               const Text(
//                                 '+92',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 15,
//                           horizontal: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: height * 0.020),
//                   Obx(() => GestureDetector(
//                     onTap: controller.isPhoneValid.value
//                         ? () => controller.verifyPhoneNumber(context)
//                         : null,
//                     child: controller.isLoading.value
//                         ? Center(child: const CircularProgressIndicator())
//                         : CustomContainer(
//                       height: height * 0.0550,
//                       width: width,
//                       color: controller.isPhoneValid.value
//                           ? AppColors.buttonColor
//                           : Colors.grey,
//                       borderRadius: 15,
//                       child: Center(
//                         child: CustomText(
//                           text: "Continue",
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.whiteTheme,
//                         ),
//                       ),
//                     ),
//                   )),
//                   SizedBox(height: height * 0.050),
//                   Center(
//                     child: CustomText(
//                       text: "By Continuing, you agree to our company's ",
//                       fontSize: 14,
//                       color: AppColors.hintGrey,
//                     ),
//                   ),
//                   Center(
//                     child: RichText(
//                       text: TextSpan(
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: AppColors.blackColor,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: 'Terms & conditions ',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                           TextSpan(
//                             text: 'and accept our ',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.blackColor,
//                             ),
//                           ),
//                           TextSpan(
//                             text: 'privacy policy',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: height * 0.050),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }