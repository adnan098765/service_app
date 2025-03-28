import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';

class TotalPriceCard extends StatelessWidget {
  final Map<String, int> selectedServices;
  final Map<String, int> servicePrices;

  const TotalPriceCard({
    required this.selectedServices,
    required this.servicePrices,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      color: AppColors.lightGrey,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ...selectedServices.entries.map((entry) {
              final serviceName = entry.key;
              final quantity = entry.value;
              final price = servicePrices[serviceName] ?? 0;
              final total = price * quantity;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(text: serviceName, fontSize: 14),
                      ),
                      CustomText(
                        text: "$quantity × Rs. $price = Rs. $total",
                        fontSize: 14,
                      ),
                    ],
                  ),
                  if (entry.key != selectedServices.entries.last.key)
                    Divider(),
                ],
              );
            }),
            Divider(thickness: 2),
            Row(
              children: [
                CustomText(
                  text: "Total Price",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                Spacer(),
                CustomText(
                  text: "Rs. ${_calculateTotalPrice()}",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalPrice() {
    int total = 0;
    selectedServices.forEach((service, quantity) {
      if (servicePrices.containsKey(service)) {
        total += servicePrices[service]! * quantity;
      }
    });
    return total;
  }
}