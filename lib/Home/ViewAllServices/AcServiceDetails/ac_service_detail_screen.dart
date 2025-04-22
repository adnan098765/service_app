import 'package:flutter/material.dart';
import 'package:untitled2/CheckOut/check_out_screen.dart';
import '../../../../AppColors/app_colors.dart';

class ACServiceScreen extends StatefulWidget {
  const ACServiceScreen({super.key});

  @override
  State<ACServiceScreen> createState() => _ACServiceScreenState();
}

class _ACServiceScreenState extends State<ACServiceScreen> {
  bool isVisible = false;
  Map<String, int> selectedServices = {};

  final List<Map<String, dynamic>> services = [
    {
      'image': 'assets/images/img.png',
      'title': 'AC Dismounting',
      'description': 'Per AC (1 to 2.5 tons)',
      'oldPrice': 1200,
      'newPrice': 1000,
      'rating': 4.8,
    },
    {
      'image': 'assets/images/img.png',
      'title': 'AC General Service',
      'description': 'Per AC (1 to 2.5 tons)',
      'oldPrice': 3500,
      'newPrice': 1850,
      'rating': 4.3,
    },
    {
      'image': 'assets/images/img.png',
      'title': 'AC General Service',
      'description': 'Per AC (1 to 2.5 tons)',
      'oldPrice': 3500,
      'newPrice': 1850,
      'rating': 4.3,
    },
    {
      'image': 'assets/images/img.png',
      'title': 'AC repairing',
      'description': 'Visit and inspection chaarges ',
      'oldPrice': 3000,
      'newPrice': 1850,
      'rating': 4.3,
    },
    {
      'image': 'assets/images/img.png',
      'title': 'Floor standing cabinet Ac general service ',
      'description': 'Visit and inspection charges ',
      'oldPrice': 2600,
      'newPrice': 1850,
      'rating': 4.3,
    },
    // Add other services here...
  ];

  final TextEditingController searchController = TextEditingController();

  void updateService(String title, bool isAdding) {
    setState(() {
      if (isAdding) {
        selectedServices[title] = (selectedServices[title] ?? 0) + 1;
      } else {
        if (selectedServices.containsKey(title) && selectedServices[title]! > 0) {
          selectedServices[title] = selectedServices[title]! - 1;
          if (selectedServices[title] == 0) {
            selectedServices.remove(title);
          }
        }
      }
      isVisible = selectedServices.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whiteTheme,
      floatingActionButton: isVisible
          ? FloatingActionButton.extended(
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                selectedServices: selectedServices,
              ),
            ),
          );
        },
        label: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
                border: Border.all(color: AppColors.whiteTheme),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${selectedServices.length}",
                style: TextStyle(
                  color: AppColors.whiteTheme,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(width:width*0.015),
            Text(
              "Continue",
              style: TextStyle(
                color: AppColors.whiteTheme,
                fontSize: 16,
              ),
            ),
            SizedBox(width:width*0.015),

            Icon(Icons.arrow_forward,color: AppColors.whiteTheme,),
            SizedBox(width:width*0.015),
          ],
        ),
      )
          : null,
      appBar: AppBar(
        title: const Text('AC Services'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade300,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.whiteTheme, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.lightWhite, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.lightWhite, width: 1),
                ),
                hintText: "Search",
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return ServiceCardWidget(
                    image: services[index]['image'],
                    title: services[index]['title'],
                    description: services[index]['description'],
                    oldPrice: services[index]['oldPrice'],
                    newPrice: services[index]['newPrice'],
                    rating: services[index]['rating'],
                    onServiceUpdate: updateService,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCardWidget extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final int oldPrice;
  final int newPrice;
  final double rating;
  final Function(String, bool) onServiceUpdate;

  const ServiceCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.oldPrice,
    required this.newPrice,
    required this.rating,
    required this.onServiceUpdate,
  });

  @override
  State<ServiceCardWidget> createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Card(
      color: AppColors.whiteTheme,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.image,
                width: width * 0.220,
                height: height * 0.090,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: width * 0.0240),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.description,
                    style: const TextStyle(color: AppColors.appColor),
                  ),
                  Row(
                    children: [
                      Text(
                        'Rs. ${widget.oldPrice}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.appColor,
                        ),
                      ),
                      SizedBox(width: width * 0.014),
                      Text(
                        'Rs. ${widget.newPrice}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.appColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: height*0.028,
                    width: width*0.12,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 14, color: AppColors.greenColor),
                        Text(
                          "${widget.rating}",
                          style: TextStyle(color: AppColors.greenColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            count == 0
                ? SizedBox(
              height: height * 0.040,
              width: width * 0.178,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => count++);
                  widget.onServiceUpdate(widget.title, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 1,
                  ),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: AppColors.whiteTheme, size: 14),
                     SizedBox(width: width*0.010),
                    Text(
                      "ADD",
                      style: TextStyle(
                        color: AppColors.whiteTheme,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Container(
              height: height * 0.040,
              width: width * 0.220,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.buttonColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (count > 0) {
                        setState(() => count--);
                        widget.onServiceUpdate(widget.title, false);
                      }
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: height * 0.042,
                      width: width * 0.072,
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.029),
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() => count++);
                      widget.onServiceUpdate(widget.title, true);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: height * 0.042,
                      width: width * 0.072,
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}