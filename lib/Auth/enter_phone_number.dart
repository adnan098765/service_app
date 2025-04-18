import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();

  bool isPhoneValid = false;

  void _onPhoneChanged(String value) {
    setState(() {
      isPhoneValid = value.length == 10;
    });
  }

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
            child: Form(
              key: _formKey,
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

                  // Phone Input
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
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: _onPhoneChanged,
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
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/img_3.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '+92',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.020),

                  // Continue Button
                  GestureDetector(
                    onTap: isPhoneValid
                        ? () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              phoneNumber: '+92${phoneNumberController.text}',
                            ),
                          ),
                        );
                      }
                    }
                        : null,
                    child: CustomContainer(
                      height: height * 0.0550,
                      width: width,
                      color: isPhoneValid ? AppColors.buttonColor : Colors.grey,
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
                        style: TextStyle(
                            fontSize: 14, color: AppColors.blackColor),
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
      ),
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
