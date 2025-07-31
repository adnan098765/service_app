import 'package:flutter/material.dart';

import '../../../widgets/custom_container.dart';
import '../../constants/app_colors.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ListTile(
          leading: CustomContainer(
            height: height * 0.032,
            width: width * 0.083,
            color: AppColors.blackColor,
            borderRadius: 5,
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        Divider(),
      ],
    );
  }
}
