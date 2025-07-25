import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/Auth/authentication_screen.dart';
import 'package:untitled2/WebPages/about_us.dart';
import 'package:untitled2/WebPages/privacy_policy.dart';
import 'package:untitled2/WebPages/terms_and_conditions.dart';
import 'package:untitled2/widgets/custom_text.dart';
import 'dart:io';
import 'Account/account_screen.dart';
import 'OrderPage/order_screen.dart';
import 'Wallet/wallet_screen.dart';
import 'menu_custom_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  void _logOu() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Log Out", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text("Are you sur!", style: TextStyle(fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: AppColors.blackColor)),
            ),
            TextButton(
              onPressed: () {

                Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthenticationScreen(customerId: 1,))); // Close the dialog
              },
              child: Text("OK", style: TextStyle(color: AppColors.blackColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      appBar: AppBar(
        backgroundColor: AppColors.whiteTheme,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: height * 0.170,

                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width:width*0.3,
                              height: height*0.130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade800,
                                image: _image != null
                                    ? DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: _image == null
                                  ? Center(child: CustomText(text: "AQ",fontSize: 18,fontWeight: FontWeight.bold,color: AppColors.whiteTheme,))
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.whiteTheme,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                       SizedBox(height:height*0.010),
                      const CustomText(text:
                        "Adnan Qasim",

                          color: AppColors.whiteTheme,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                      ),
                       CustomText(text:
                        "adnanqasim804@gmail.com",fontSize: 14,
                        color: AppColors.lightGrey,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.030),
              Column(
                children:  [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountScreen()));
                    },
                      child: MenuTile(icon: Icons.person, title: "Account")),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreenProfile()));
                    },
                      child: MenuTile(icon: Icons.list, title: "Orders")),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>WalletScreen()));
                      },
                      child: MenuTile(icon: Icons.account_balance_wallet, title: "Wallet")),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
                    },
                      child: MenuTile(icon: Icons.help_outline_outlined, title: "About us")),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditions()));
                    },
                      child: MenuTile(icon: Icons.request_page_sharp, title: "Terms and Conditions")),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));
                      },
                      child: MenuTile(icon: Icons.lock_person_outlined, title: "Privacy policy")),
                  InkWell(
                    onTap: _logOu,
                      child: MenuTile(icon: Icons.logout, title: "Log Out")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}