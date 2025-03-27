import 'package:flutter/material.dart';
import '../../AppColors/app_colors.dart';
import 'ViewAllServices/AcServiceDetails/ac_service_detail_screen.dart';

class CategoriesGrid extends StatefulWidget {
  const CategoriesGrid({super.key});

  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.format_paint, 'label': 'Painting', 'route': '/painting'},
    {
      'icon': Icons.cleaning_services,
      'label': 'Cleaning',
      'route': '/cleaning',
    },
    {'icon': Icons.local_shipping, 'label': 'Van', 'route': '/van'},
    {'icon': Icons.build, 'label': 'Repair', 'route': '/repair'},
    {'icon': Icons.engineering, 'label': 'Labour', 'route': '/labour'},
    {'icon': Icons.plumbing, 'label': 'Plumbing', 'route': '/plumbing'},
  ];

  void _navigate(BuildContext context, int index) {
    final route = categories[index]['route'];

    // You can replace this with your actual navigation logic
    // For now, it just shows which category was selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to ${categories[index]['label']}'),
        duration: Duration(milliseconds: 500),
      ),
    );

    // Example of actual navigation:
    // Navigator.pushNamed(context, route);

    // Or if you have separate screens:

    switch(index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ACServiceScreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ACServiceScreen()));
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ACServiceScreen()));
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ACServiceScreen()));
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ACServiceScreen()));
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ACServiceScreen()));

        // Navigator.push(context, MaterialPageRoute(builder: (context) => CleaningScreen()));
        break;
      // Add cases for other categories
    }

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
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
              _navigate(context, index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.appColor : AppColors.whiteTheme,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                gradient:
                    isSelected
                        ? LinearGradient(
                          colors: [AppColors.appColor, AppColors.darkBlueShade],
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
                    color: isSelected ? Colors.white : AppColors.appColor,
                    size: height * 0.045,
                  ),
                  SizedBox(height: height * 0.010),
                  Text(
                    categories[index]['label'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.appColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
