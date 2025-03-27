import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';

import '../Home/home_screen.dart';
import '../Order/order_tabbar.dart';
import '../Profile/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({
    super.key,
    // required double latitude,
    // required double longitude,
    // String? address,
  });

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    OrdersScreen(),
    // ChatScreen(),
    ProfileScreen(),
  ];

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
          // BottomNavigationBarItem(icon: Icon(Icons.message, size: 28), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: '',
          ),
        ],
      ),
    );
  }
}
