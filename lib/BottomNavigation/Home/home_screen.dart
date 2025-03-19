import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';

import 'ViewAllServices/home_services_screen.dart';
import 'categories_page.dart';
import 'maintenance_page.dart';
import 'offer_page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: AppColors.lightGrey,
            title: const Text('Home'),
            centerTitle: true,
            actions: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/img.png'),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      drawer: Padding(padding: EdgeInsets.only(top: 40), child: Drawer()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Text(
                'Welcome To Our App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: height * 0.020),
            OfferBanner(),
            SizedBox(height: height * 0.020),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: "Categories", fontSize: 16),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeServicesScreen()));
                    },
                    child: CustomText(
                      text: "View All",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            CategoriesGrid(),
            SizedBox(height: 20),
            MaintenanceBanner(),
          ],
        ),
      ),
    );
  }
}
