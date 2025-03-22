import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';

class MaintenanceBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maintained by Mahir Company',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: CustomText(
                          text: "Residential",
                          color: AppColors.whiteTheme,
                        ),
                        backgroundColor: AppColors.darkBlueShade,
                      ),
                      SizedBox(width: 2),
                      Chip(
                        label: CustomText(
                          text: "Commercial",
                          color: AppColors.whiteTheme,
                        ),
                        backgroundColor: AppColors.darkBlueShade,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/img.png', height: height*0.060),
          ],
        ),
      ),
    );
  }
}
