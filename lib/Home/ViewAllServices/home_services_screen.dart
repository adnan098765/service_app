import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_container.dart';
import 'package:untitled2/widgets/custom_text.dart';

import 'AcServiceDetails/ac_service_detail_screen.dart';
import 'most_booked_services.dart';

class HomeServicesScreen extends StatefulWidget {
  const HomeServicesScreen({super.key});

  @override
  State<HomeServicesScreen> createState() => _HomeServicesScreenState();
}

class _HomeServicesScreenState extends State<HomeServicesScreen> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = -1;

  final List<Map<String, dynamic>> categories = [
    {'label': 'AC Services', 'icon': Icons.ac_unit},
    {'label': 'Carpenter', 'icon': Icons.handyman},
    {'label': 'Electrician', 'icon': Icons.electrical_services},
    {'label': 'Geyser', 'icon': Icons.water},
    {'label': 'Handyman', 'icon': Icons.build},
    {'label': 'Home Appliances', 'icon': Icons.kitchen},
    {'label': 'Home Inspection', 'icon': Icons.search},
    {'label': 'Painter', 'icon': Icons.format_paint},
    {'label': 'Pest Control', 'icon': Icons.bug_report},
    {'label': 'Plumber', 'icon': Icons.plumbing},
  ];

  void _navigateTo(BuildContext context, int index) {
    List<Widget> screens = List.generate(
      categories.length,
          (i) => const ACServiceScreen(), // Replace with actual screens
    );

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
            serviceName: categories[index]['label'],
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
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
              // actions: [
              //   const Icon(Icons.phone),
              //   SizedBox(width: width * 0.05),
              //   const Icon(Icons.notifications),
              //   SizedBox(width: width * 0.05),
              // ],
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          _navigateTo(context, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.appColor
                                : AppColors.whiteTheme,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            gradient: isSelected
                                ? LinearGradient(
                              colors: [
                                AppColors.appColor,
                                AppColors.darkBlueShade
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                categories[index]['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.appColor,
                                size: height * 0.045,
                              ),
                              SizedBox(height: height * 0.010),
                              Text(
                                categories[index]['label'],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.appColor,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(height: height * 0.03),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// Search Bar Delegate
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

// Fallback Detail Screen
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
