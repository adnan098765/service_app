import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/widgets/custom_text.dart';

import '../../AppColors/app_colors.dart';

class OfferBanner extends StatelessWidget {
  const OfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.appColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: '50% OFF',

                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteTheme,
                  ),
                  CustomText(
                    text: 'In Renovation Assistance Service',
                    color: AppColors.blueShade,
                    fontSize: 15,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueShade,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomText(text:
                      'BOOK NOW',

                        color: AppColors.whiteTheme,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                    ),
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/img.png', height: 100),
          ],
        ),
      ),
    );
  }
}
