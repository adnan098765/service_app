import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/Order/previous_order_screen.dart';
import 'package:untitled2/Order/scheduled_screen.dart';

import 'ActiveOrderScreen.dart';


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.whiteTheme,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: AppColors.appColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.appColor,
            tabs: [
              Tab(text: "Active"),
              Tab(text: "Previous"),
              Tab(text: "Scheduled"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ActiveOrderScreen(),
            const PreviousOrderScreen(),
            const ScheduledScreen(),
          ],
        ),
      ),
    );
  }
}

