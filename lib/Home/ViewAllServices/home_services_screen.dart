import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';

import 'package:untitled2/widgets/custom_container.dart';
import 'package:untitled2/widgets/custom_text.dart';

import 'AcServiceDetails/ac_service_detail_screen.dart';
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
        padding: EdgeInsets.only(top: height * 0.02),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text("Home Services"),
              floating: true,
              pinned: true,
              leading: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              actions: [
                Icon(Icons.phone),
                SizedBox(width: width * 0.05),
                Icon(Icons.notifications),
                SizedBox(width: width * 0.05),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              floating: false,
              delegate: _SearchBarDelegate(searchController),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: height * 0.024),
                const ServiceList(),
                SizedBox(height: height * 0.024),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: const Text(
                    'All Services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: height * 0.01),
                GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.01,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: services.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: width * 0.03,
                    mainAxisSpacing: height * 0.02,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _navigateTo(context, index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.52,
                              height: height * 0.06,
                              decoration: BoxDecoration(
                                color: AppColors.blueAccentColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                services[index]['icon'],
                                size: height * 0.03,
                                color: AppColors.appColor,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                              child: Text(
                                services[index]['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: height * 0.016,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>CleaningServiceScreen()));
                      },
                      child: CustomContainer(
                        height: height * 0.07,
                        width: width * 0.3,
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
                SizedBox(height: height * 0.03),
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
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(width * 0.03),
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