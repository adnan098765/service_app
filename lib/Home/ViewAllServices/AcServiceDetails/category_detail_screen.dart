import 'package:flutter/material.dart';
import 'package:untitled2/CheckOut/check_out_screen.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import '../../../Models/all_category_services.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Category category;
  final List<Services> services;

  const CategoryDetailsScreen({
    super.key,
    required this.category,
    required this.services,
  });

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  bool isVisible = false;
  Map<String, int> selectedServices = {};

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
            SizedBox(width: width * 0.015),
            Text(
              "Continue",
              style: TextStyle(
                color: AppColors.whiteTheme,
                fontSize: 16,
              ),
            ),
            SizedBox(width: width * 0.015),
            Icon(
              Icons.arrow_forward,
              color: AppColors.whiteTheme,
            ),
            SizedBox(width: width * 0.015),
          ],
        ),
      )
          : null,
      appBar: AppBar(
        title: Text(widget.category.categoryName ?? 'Category'),
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
              keyboardType: TextInputType.text,
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
                hintText: "Search services",
              ),
            ),
            Expanded(
              child: widget.services.isEmpty
                  ? Center(
                child: Text(
                  'No services available for ${widget.category.categoryName}',
                  style: const TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: widget.services.length,
                itemBuilder: (context, index) {
                  final service = widget.services[index];
                  return ServiceCardWidget(
                    image: service.image ?? 'assets/images/default.png',
                    title: service.serviceName ?? 'Unknown Service',
                    description: service.description ?? 'No description',
                    oldPrice:
                    int.tryParse(service.regularPrice ?? '0') ?? 0,
                    newPrice: int.tryParse(
                        service.salePrice ?? service.regularPrice ?? '0') ??
                        0,
                    rating: service.isFeatured == true ? 4.8 : 4.3,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.image.startsWith('http')
                  ? Image.network(
                widget.image,
                width: width * 0.2, // Reduced width to prevent overflow
                height: height * 0.09,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: width * 0.2,
                  color: AppColors.appColor,
                ),
              )
                  : Image.asset(
                widget.image,
                width: width * 0.2,
                height: height * 0.09,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  size: width * 0.2,
                  color: AppColors.appColor,
                ),
              ),
            ),
            SizedBox(width: width * 0.02),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.description,
                    style: const TextStyle(color: AppColors.appColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                      SizedBox(width: width * 0.01),
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
                    height: height * 0.028,
                    width: width * 0.12,
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
            SizedBox(width: width * 0.02),
            count == 0
                ? SizedBox(
              height: height * 0.04,
              width: width * 0.15, // Reduced width to prevent overflow
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add,
                        color: AppColors.whiteTheme, size: 14),
                    SizedBox(width: width * 0.01),
                    Text(
                      "ADD",
                      style: TextStyle(
                        color: AppColors.whiteTheme,
                        fontWeight: FontWeight.bold,
                        fontSize: 12, // Reduced font size
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Container(
              height: height * 0.04,
              width: width * 0.18, // Reduced width to prevent overflow
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.buttonColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      height: height * 0.04,
                      width: width * 0.06,
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => count++);
                      widget.onServiceUpdate(widget.title, true);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: height * 0.04,
                      width: width * 0.06,
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
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