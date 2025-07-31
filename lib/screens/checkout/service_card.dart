import 'package:flutter/material.dart';
import 'package:untitled2/screens/checkOut/quantity_selector.dart';

import '../../constants/app_colors.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String originalPrice;
  final String discountedPrice;
  final double rating;
  final int count;
  final Function(int) onQuantityChanged;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.rating,
    required this.count,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset("assets/images/img.png", width: 80, height: 80, fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(description, style: TextStyle(fontSize: 14, color: AppColors.appColor)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        originalPrice,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.appColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        discountedPrice,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.appColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.greenColor, size: 16),
                      Text("$rating", style: TextStyle(fontSize: 14, color: AppColors.greenColor)),
                      Spacer(),
                      QuantitySelector(count: count, onQuantityChanged: onQuantityChanged),
                    ],
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
