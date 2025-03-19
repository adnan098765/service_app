import 'package:flutter/material.dart';
import '../../AppColors/app_colors.dart';

class CategoriesGrid extends StatefulWidget {
  const CategoriesGrid({super.key});

  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.format_paint, 'label': 'Painting'},
    {'icon': Icons.cleaning_services, 'label': 'Cleaning'},
    {'icon': Icons.local_shipping, 'label': 'Van'},
    {'icon': Icons.build, 'label': 'Repair'},
    {'icon': Icons.engineering, 'label': 'Labour'},
    {'icon': Icons.plumbing, 'label': 'Plumbing'},
  ];

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
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: SizedBox(
              height: height * 0.15,
              child: Card(
                color: isSelected ? AppColors.appColor : AppColors.whiteTheme,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color:
                        isSelected ? Colors.transparent : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                elevation: isSelected ? 2 : 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categories[index]['icon'],
                      color: isSelected ? Colors.white : Colors.black,
                      size: 35,
                    ),
                     SizedBox(height:height*0.010),
                    Text(
                      categories[index]['label'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
