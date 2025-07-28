
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../AppColors/app_colors.dart';
import '../Controlller/update _profile_controller.dart';
import '../SharedPreference/shared_preference.dart';
import '../widgets/custom_text.dart';


class AuthenticationScreen extends StatefulWidget {
  final int customerId;
  final String? token;
  final String? phoneNumber;

  const AuthenticationScreen({
    super.key,
    required this.customerId,
    this.token,
    this.phoneNumber,
  });

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedGender = "Male";

  @override
  void initState() {
    super.initState();
    debugPrint("🟢 [AuthenticationScreen] Initialized with phoneNumber: ${widget.phoneNumber}, customerId: ${widget.customerId}");
    _loadUserProfile();
    if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
      phoneNumberController.text = widget.phoneNumber!;
      controller.isPhoneValid.value = widget.phoneNumber!.length == 10;
      debugPrint("📱 [AuthenticationScreen] Prefilled phoneNumberController with: ${widget.phoneNumber}");
    }
  }

  Future<void> _loadUserProfile() async {
    final profile = await SharedPreferencesHelper.getUserProfile();
    if (profile != null) {
      firstNameController.text = profile['first_name'] ?? '';
      secondNameController.text = profile['last_name'] ?? '';
      emailController.text = profile['email'] ?? '';
      selectedGender = profile['gender']?.capitalize ?? 'Male';
      controller.isNameValid.value = firstNameController.text.trim().isNotEmpty && secondNameController.text.trim().isNotEmpty;
      controller.isSecondNameValid.value = secondNameController.text.trim().isNotEmpty;
      debugPrint("📋 [AuthenticationScreen] Prefilled profile: $profile");
      setState(() {});
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    firstNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    debugPrint("🧹 [AuthenticationScreen] Disposed controllers");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Adaptive.w(5)),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Adaptive.h(4)),
                  CustomText(
                    text: "Welcome to our company",
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appColor,
                  ),
                  CustomText(
                    text: "Please enter your details to continue",
                    fontSize: 16.sp,
                    color: AppColors.greyColor,
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
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
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
                  SizedBox(height: Adaptive.h(2.5)),
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
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        controller.isNameValid.value =
                            value.trim().isNotEmpty && secondNameController.text.trim().isNotEmpty;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your first name';
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
                        hintText: "Enter your first name",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Adaptive.h(2),
                          horizontal: Adaptive.w(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(2.5)),
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
                      controller: secondNameController,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        controller.isSecondNameValid.value = value.trim().isNotEmpty;
                        controller.isNameValid.value =
                            firstNameController.text.trim().isNotEmpty && value.trim().isNotEmpty;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your last name';
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
                        hintText: "Enter your last name",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Adaptive.h(2),
                          horizontal: Adaptive.w(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(2.5)),
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
                    child: DropdownButtonFormField<String>(
                      value: selectedGender,
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
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey[600],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Adaptive.w(4),
                          vertical: Adaptive.h(2),
                        ),
                      ),
                      dropdownColor: Colors.grey[200],
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                      items: ["Male", "Female", "Other"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: Adaptive.h(2.5)),
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Enter a valid email address';
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
                        hintText: "Enter your email",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Adaptive.h(2),
                          horizontal: Adaptive.w(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(4)),
                  Obx(() => GestureDetector(
                    onTap: controller.isLoading.value
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        debugPrint(
                            "📲 [AuthenticationScreen] Submitting profile with phone: ${phoneNumberController.text}, customerId: ${widget.customerId}");
                        await controller.updateProfile(
                          phoneNumber: phoneNumberController.text,
                          firstName: firstNameController.text,
                          secondName: secondNameController.text,
                          email: emailController.text,
                          gender: selectedGender,
                          customerId: widget.customerId,
                          token: widget.token,
                        );
                      }
                    },
                    child: controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                      height: Adaptive.h(6),
                      width: width,
                      decoration: BoxDecoration(
                        color: (controller.isPhoneValid.value &&
                            controller.isNameValid.value &&
                            controller.isSecondNameValid.value &&
                            emailController.text.isNotEmpty)
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
                  SizedBox(height: Adaptive.h(4)),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Adaptive.w(4)),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                          children: [
                            TextSpan(text: "By continuing, you agree to our "),
                            TextSpan(
                              text: "Terms",
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Adaptive.h(2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}