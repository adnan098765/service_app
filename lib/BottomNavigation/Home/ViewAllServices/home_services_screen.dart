import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/BottomNavigation/Home/CleaningServices/cleaning_service_screen.dart';
import 'package:untitled2/BottomNavigation/Home/ViewAllServices/AcServiceDetails/ac_service_detail_screen.dart';
import 'package:untitled2/BottomNavigation/Home/ViewAllServices/service_icon.dart';
import 'package:untitled2/widgets/custom_container.dart';
import 'package:untitled2/widgets/custom_text.dart';

import 'most_booked_services.dart';

class HomeServicesScreen extends StatelessWidget {
  HomeServicesScreen({super.key});
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> services = [
    {'name': 'AC Services', 'icon': Icons.ac_unit},
    {'name': 'Carpenter', 'icon': Icons.handyman},
    {'name': 'Electrician', 'icon': Icons.electrical_services},
    {'name': 'Geyser', 'icon': Icons.water},
    {'name': 'Handyman', 'icon': Icons.build},
    {'name': 'Home Appliances', 'icon': Icons.kitchen},
    {'name': 'Home Inspection', 'icon': Icons.search},
    {'name': 'Painter', 'icon': Icons.format_paint},
    {'name': 'Pest Control', 'icon': Icons.bug_report},
    {'name': 'Plumber', 'icon': Icons.plumbing},
  ];

  // Function to navigate based on index
  void _navigateTo(BuildContext context, int index) {
    List<Widget> screens = [
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
      const ACServiceScreen(),
    ];

    if (index < screens.length) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screens[index]),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailsScreen(
            serviceName: services[index]['name'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("Home Services"),
              floating: true,
              pinned: true,
              leading: const Icon(Icons.arrow_back),
              actions: const [
                Icon(Icons.phone),
                SizedBox(width: 10),
                Icon(Icons.notifications),
                SizedBox(width: 10),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SearchBarDelegate(searchController),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                const ServiceList(),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'All Services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2, // Adjust spacing
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _navigateTo(context, index),
                      child: ServiceIcon(
                        name: services[index]['name'],
                        icon: services[index]['icon'],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16), // Reduced space before explore button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: InkWell(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>CleaningServiceScreen()));
                      },
                      child: CustomContainer(
                        height: height * 0.070,
                        width: width*0.3,
                        borderRadius: 20,
                        color: AppColors.blueAccentColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Explore cleaning service",
                              fontWeight: FontWeight.bold,
                            ),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.030,)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// Persistent Search Bar Delegate
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;

  _SearchBarDelegate(this.controller);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade300,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.whiteTheme,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.lightWhite,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.lightWhite,
              width: 1,
            ),
          ),
          hintText: "Search",
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

// Example Service Details Screen
class ServiceDetailsScreen extends StatelessWidget {
  final String serviceName;

  const ServiceDetailsScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
      ),
      body: Center(
        child: Text(
          'Details for $serviceName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
