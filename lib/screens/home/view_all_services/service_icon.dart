import 'package:flutter/material.dart';

import '../../../../widgets/custom_container.dart';
import '../../../constants/app_colors.dart';

class ServiceIcon extends StatelessWidget {
  final String name;
  final IconData icon;

  const ServiceIcon({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Card(
          color: AppColors.whiteTheme,
          elevation: 5,
          child: CustomContainer(
            height: height * 0.110,
            width: width * 0.260,
            color: AppColors.whiteTheme,
            child: Icon(icon, color: AppColors.blueShade, size: 30),
          ),
        ),
        SizedBox(height: height * 0.010),
        Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
