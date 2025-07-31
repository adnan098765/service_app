import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class MaintenanceBanner extends StatelessWidget {
  const MaintenanceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.grey300, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maintained by Mahir Company', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8), // Added spacing
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 80, // Set minimum width
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.darkBlueShade,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              "Residential",
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.whiteTheme,
                              ),
                            ),
                            // child: CustomText(
                            //   text: "Commercial",
                            //   color: AppColors.whiteTheme,
                            //   fontSize: 12, // Reduced font size
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 80, // Set minimum width
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.darkBlueShade,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              "Commercial",
                              style: TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                                color: AppColors.whiteTheme,
                              ),
                            ),
                            // child: CustomText(
                            //   text: "Commercial",
                            //   color: AppColors.whiteTheme,
                            //   fontSize: 12, // Reduced font size
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/img.png', height: height * 0.060),
          ],
        ),
      ),
    );
  }
}
