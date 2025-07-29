import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double borderRadius;
  final Widget? child;

  const CustomContainer({
    super.key,
    this.width = 100,
    this.height = 100,
    this.color = Colors.blue, // Default color
    this.borderRadius = 10,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
