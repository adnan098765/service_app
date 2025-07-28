// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:untitled2/AppColors/app_colors.dart';
// import 'package:untitled2/Controlller/add_address_controller.dart';
// import 'package:untitled2/Home/home_screen.dart';
// import 'package:untitled2/Order/order_tabbar.dart';
// import 'package:untitled2/Profile/profile_screen.dart';
//
// class BottomNavScreen extends StatefulWidget {
//   final double? latitude;
//   final double? longitude;
//   final String? address;
//   final String? city;
//   final bool? isManualLocation;
//
//   const BottomNavScreen({
//     super.key,
//     this.latitude,
//     this.longitude,
//     this.address,
//     this.city,
//     this.isManualLocation,
//   });
//
//   @override
//   State<BottomNavScreen> createState() => _BottomNavScreenState();
// }
//
// class _BottomNavScreenState extends State<BottomNavScreen> {
//   int _selectedIndex = 0;
//   late List<Widget> _screens;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize AddAddressController
//     final addAddressController = Get.put(AddAddressController(), permanent: true);
//     // Ensure addresses are loaded
//     addAddressController.loadSavedAddresses();
//     _screens = [
//       HomeScreen(
//         latitude: widget.latitude ?? 0.0,
//         longitude: widget.longitude ?? 0.0,
//         address: widget.address ?? "Unknown",
//         city: widget.city ?? "Unknown",
//         isManualLocation: widget.isManualLocation ?? false,
//       ),
//       const OrdersScreen(),
//       const ProfileScreen(),
//     ];
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: AppColors.appColor,
//         unselectedItemColor: AppColors.hintGrey,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         elevation: 5,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.list, size: 28), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: ''),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../AppColors/app_colors.dart';
import '../Controlller/add_address_controller.dart';
import '../Home/home_screen.dart';
import '../Order/order_tabbar.dart';
import '../Profile/profile_screen.dart';


class BottomNavScreen extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final bool? isManualLocation;

  const BottomNavScreen({
    super.key,
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.isManualLocation,
  });

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    Get.put(AddAddressController()); // Initialize controller here
    _screens = [
      HomeScreen(
        latitude: widget.latitude ?? 0.00,
        longitude: widget.longitude ?? 0.00,
        address: widget.address,
        city: widget.city,
        isManualLocation: widget.isManualLocation ?? true,
      ),
      const OrdersScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.appColor,
        unselectedItemColor: AppColors.hintGrey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 5,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: Adaptive.w(7)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: Adaptive.w(7)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: Adaptive.w(7)),
            label: '',
          ),
        ],
      ),
    );
  }
}
