// import 'package:flutter/material.dart';
// import 'package:untitled2/widgets/custom_text.dart';
//
// import '../../constants/app_colors.dart';
// import '../Models/all_category_services.dart';
//
// class TotalPriceCard extends StatelessWidget {
//   final Map<String, int> selectedServices;
//   final List<Map<String, dynamic>> selectedServiceDetails; // Changed from List<Map<String, Object>>
//   const   TotalPriceCard({super.key, required this.selectedServices, required this.selectedServiceDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     // Calculate total price using selectedServiceDetails
//     double totalPrice = selectedServiceDetails.fold(0.0, (sum, item) {
//       final service = item['service'] as Services?;
//       final quantity = item['quantity'] as int? ?? 0;
//       final price = double.tryParse(service?.salePrice ?? service?.regularPrice ?? '0') ?? 0.0;
//       return sum + (price * quantity);
//     });
//
//     debugPrint(
//       'TotalPriceCard: Calculated totalPrice=$totalPrice for selectedServices=$selectedServices, selectedServiceDetails=$selectedServiceDetails',
//     );
//
//     return Card(
//       color: AppColors.whiteTheme,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CustomText(text: 'Total Price', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBlueShade),
//             CustomText(
//               text: 'Rs. ${totalPrice.toStringAsFixed(2)}',
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.appColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:untitled2/widgets/custom_text.dart';
import '../../constants/app_colors.dart';
import '../Models/all_category_services.dart';

class TotalPriceCard extends StatelessWidget {
  final Map<String, int> selectedServices;
  final List<Map<String, Object>> selectedServiceDetails;

  const TotalPriceCard({
    super.key,
    required this.selectedServices,
    required this.selectedServiceDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total price using selectedServiceDetails
    double totalPrice = selectedServiceDetails.fold(0.0, (sum, item) {
      final service = item['service'] as Services?;
      final quantity = item['quantity'] as int? ?? 0;
      final price = double.tryParse(service?.salePrice ?? service?.regularPrice ?? '0') ?? 0.0;
      return sum + (price * quantity);
    });

    debugPrint(
      'TotalPriceCard: Calculated totalPrice=$totalPrice for selectedServices=$selectedServices, selectedServiceDetails=$selectedServiceDetails @ ${DateTime.now().toIso8601String()}',
    );

    return Card(
      color: AppColors.whiteTheme,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: 'Total Price',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlueShade,
            ),
            CustomText(
              text: 'Rs. ${totalPrice.toStringAsFixed(2)}',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.appColor,
            ),
          ],
        ),
      ),
    );
  }
}
