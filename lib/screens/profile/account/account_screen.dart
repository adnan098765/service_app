import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/custom_text.dart';
import '../../../constants/app_colors.dart';
import 'account_custom_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () {}),
        title: const Text("Account", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 100, color: Colors.black),
                Column(
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
                                    width: width * 0.15,
                                    height: height * 0.120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade800,
                                      image:
                                          _image != null
                                              ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
                                              : null,
                                    ),
                                    child:
                                        _image == null
                                            ? Center(
                                              child: CustomText(
                                                text: "AQ",
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.whiteTheme,
                                              ),
                                            )
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
                                        child: Icon(Icons.edit, size: 16, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.010),
                            const CustomText(
                              text: "Adnan Qasim",

                              color: AppColors.whiteTheme,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(text: "adnanqasim804@gmail.com", fontSize: 14, color: AppColors.lightGrey),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Adnan Qasim",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text("adnanqasim804@gmail.com", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: const [
                  ProfileInfoTile(title: "Name", subtitle: "Adnan Qasim", editable: true),
                  ProfileInfoTile(title: "Gender", subtitle: "Female", editable: true),
                  ProfileInfoTile(title: "Phone Number", subtitle: "+92 326 0483582"),
                  ProfileInfoTile(title: "Email Address", subtitle: "adnanqasim804@gmail.com", editable: true),
                  ProfileInfoTile(
                    title: "Unlink Facebook Account",
                    subtitle: "Unlink Facebook Account and associated Data",
                    isNavigation: true,
                  ),
                  ProfileInfoTile(
                    title: "Delete Account",
                    subtitle: "Delete Account and associated Data",
                    isNavigation: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
