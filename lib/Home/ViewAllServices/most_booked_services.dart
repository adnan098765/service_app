import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10),
          ServiceCard(
            title: 'AC Installation',
            description: 'Installation with 10 Feet pipe (1 to 2.5 tons)',
            originalPrice: 'Rs. 3250',
            discountedPrice: 'Rs. 2500',
          ),
          const SizedBox(width: 10),
          ServiceCard(
            title: 'UPS installation',
            description: 'vary after inspection',
            originalPrice: '',
            discountedPrice: 'Rs. 1300',
          ),
          const SizedBox(width: 10),
          ServiceCard(
            title: 'AC general service',
            description: 'Wiring and circuit repairs',
            originalPrice: 'Rs. 3500',
            discountedPrice: 'Rs. 1850',
          ),
          const SizedBox(width: 10),
          ServiceCard(
            title: 'Electrical wiring',
            description: 'Furniture assembly and repairs',
            originalPrice: '',
            discountedPrice: 'Rs. 500',
          ),
          const SizedBox(width: 10),
          ServiceCard(
            title: 'Cleaning Service',
            description: 'Deep cleaning for homes and offices',
            originalPrice: '',
            discountedPrice: 'Rs. 800',
          ),
          const SizedBox(width: 10),
          ServiceCard(
            title: 'Muslim shower replacement',
            description: 'per muslim shower',
            originalPrice: '',
            discountedPrice: 'Rs. 800',
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String originalPrice;
  final String discountedPrice;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.148,
      width: width*0.800,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            height: height*0.110,
            width: width*0.250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(image: AssetImage("assets/images/img.png",),fit: BoxFit.cover )
            ),
          ),

           SizedBox(width:width*0.020),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(description, style: const TextStyle(color: Colors.white70)),
                Row(
                  children: [
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                     SizedBox(width:width*0.015),
                    Text(
                      discountedPrice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}