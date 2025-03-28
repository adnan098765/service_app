import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import '../Home/home_screen.dart';
import '../Order/order_tabbar.dart';
import '../Profile/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final bool isManualLocation;

  const BottomNavScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    required this.isManualLocation,
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
    _screens = [
      HomeScreen(
        latitude: widget.latitude,
        longitude: widget.longitude,
        address: widget.address,
        city: widget.city,
        isManualLocation: widget.isManualLocation,
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list, size: 28), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: '',
          ),
        ],
      ),
    );
  }
}