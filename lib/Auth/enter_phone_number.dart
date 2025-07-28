
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../AppColors/app_colors.dart';
import '../Controlller/phone_number_controller.dart';
import '../widgets/custom_text.dart';

import 'authentication_screen.dart';

class EnterPhoneNumber extends StatelessWidget {
  const EnterPhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final PhoneNumberController controller = Get.put(PhoneNumberController());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Adaptive.w(4)),
          child: SafeArea(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Adaptive.h(4)),
                  CustomText(
                    text: "Welcome to our company",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text: "Please enter your phone number to continue",
                    fontSize: 16.sp,
                  ),
                  SizedBox(height: Adaptive.h(4)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: controller.onPhoneChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.length != 10) {
                          return 'Enter valid 10-digit number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.appColor,
                            width: 1.5,
                          ),
                        ),
                        hintText: "3XX XXXXXXX",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: Adaptive.w(2), right: Adaptive.w(1)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/img_3.png',
                                width: Adaptive.w(8),
                                height: Adaptive.w(8),
                              ),
                              SizedBox(width: Adaptive.w(1)),
                              Text(
                                '+92',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Adaptive.h(2),
                          horizontal: Adaptive.w(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(2)),
                  Obx(() => GestureDetector(
                    onTap: controller.isPhoneValid.value
                        ? () => controller.verifyPhoneNumber(context)
                        : null,
                    child: controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                      height: Adaptive.h(5.5),
                      width: width,
                      decoration: BoxDecoration(
                        color: controller.isPhoneValid.value
                            ? AppColors.buttonColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomText(
                          text: "Continue",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteTheme,
                        ),
                      ),
                    ),
                  )),
                  SizedBox(height: Adaptive.h(5)),
                  Center(
                    child: CustomText(
                      text: "By Continuing, you agree to our company's ",
                      fontSize: 14.sp,
                      color: AppColors.hintGrey,
                    ),
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.blackColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms & conditions ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: 'and accept our ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.blackColor,
                            ),
                          ),
                          TextSpan(
                            text: 'privacy policy',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(5)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}