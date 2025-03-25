import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/Auth/otp_screen.dart';
import 'package:untitled2/widgets/custom_container.dart';
import 'package:untitled2/widgets/custom_text.dart';

class EnterPhoneNumber extends StatefulWidget {
  const EnterPhoneNumber({super.key});

  @override
  State<EnterPhoneNumber> createState() => _EnterPhoneNumberState();
}

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String selectedGender = "Male";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                CustomText(
                  text: "Welcome to our company",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  text: "Please enter your phone number to continue",
                  fontSize: 16,
                ),
                SizedBox(height: height * 0.040),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.lightGrey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.lightWhite,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.lightWhite,
                        width: 1,
                      ),
                    ),
                    hintText: "Enter phone number",
                  ),
                ),
                SizedBox(height: height * 0.020),


                SizedBox(height: height * 0.020),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtpScreen()),
                    );
                  },
                  child: CustomContainer(
                    height: height * 0.0550,
                    width: width,
                    color: AppColors.blackColor,
                    borderRadius: 15,
                    child: Center(
                      child: CustomText(
                        text: "Continue",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteTheme,
                      ),
                    ),
                  ),
                ),
                Image(image: AssetImage("assets/images/img_2.png"), height: height * 0.3, width: width),
                SizedBox(height: height * 0.050),
                Center(
                  child: CustomText(
                    text: "By Continuing, you agree to our company's ",
                    fontSize: 14,
                    color: AppColors.hintGrey,
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: AppColors.blackColor),
                      children: [
                        TextSpan(
                          text: 'Terms & conditions ',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: 'and accept our ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: 'privacy policy',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.050),
              ],
            ),
          ),
        ),
      ),
    );
  }
}