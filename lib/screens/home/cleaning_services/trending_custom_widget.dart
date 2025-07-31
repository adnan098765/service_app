import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class TrendingCustomWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String orders;
  final double rating;
  final String description;
  final double oldPrice;
  final double newPrice;

  const TrendingCustomWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.orders,
    required this.rating,
    required this.description,
    required this.oldPrice,
    required this.newPrice,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.whiteTheme,
        boxShadow: [BoxShadow(color: AppColors.lightBlack, blurRadius: 3, spreadRadius: 1)],
      ),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imageUrl, height: height * 0.110, width: width, fit: BoxFit.cover),
          ),
          SizedBox(height: height * 0.010),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Row(
            children: [
              Icon(Icons.check_circle_outline, size: 14, color: AppColors.hintGrey),
              SizedBox(width: 4),
              Text("$orders orders", style: TextStyle(fontSize: 12, color: AppColors.hintGrey)),
              Spacer(),
              Icon(Icons.star, size: 14, color: AppColors.yellowColor),
              Text("$rating", style: TextStyle(fontSize: 12, color: AppColors.yellowColor)),
            ],
          ),
          Text(description, style: TextStyle(fontSize: 12, color: AppColors.hintGrey)),
          Row(
            children: [
              Text(
                "Rs. $oldPrice",
                style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12, color: Colors.grey),
              ),
              SizedBox(width: width * 0.05),
              Text("Rs. $newPrice", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
