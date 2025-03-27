import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  bool isChecked = false;
  bool isCheckedCash = false;
  bool isCheckedCardBank = false;
  String selectedPaymentMethod = "Cash"; // Default payment method

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.payment),
              SizedBox(width: 8),
              Text("Payment Methods", style: TextStyle(fontSize: 14)),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.money),
                    SizedBox(width: 8),
                    Text("Cash"),
                    Spacer(),
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      activeColor: AppColors.darkBlueShade,
                      value: isCheckedCash,
                      onChanged: (value) {
                        setState(() {
                          isCheckedCash = value!;
                          if (isCheckedCash) {
                            selectedPaymentMethod = "Cash";
                            isCheckedCardBank = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.add_card_outlined),
                    SizedBox(width: 8),
                    Text("Card Bank Transfer"),
                    Spacer(),
                    Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Primary"),
                      ),
                    ),
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      activeColor: AppColors.darkBlueShade,
                      value: isCheckedCardBank,
                      onChanged: (value) {
                        setState(() {
                          isCheckedCardBank = value!;
                          if (isCheckedCardBank) {
                            selectedPaymentMethod = "Card Bank Transfer";
                            isCheckedCash = false; // Unselect the other option
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Image(
                  image: AssetImage("assets/images/payment.jpeg"),
                  height: 20,
                  width: 100,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        // Payment Method Container
        GestureDetector(
          onTap: () {
            _showPaymentMethodDialog(context);
          },
          child: Container(
            height: height * 0.086,
            width: width * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.lightGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payment,
                        size: 16,
                        color: AppColors.darkBlueShade,
                      ),
                      SizedBox(width: width * 0.020),
                      CustomText(
                        text: "Payment Method",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.008),
                  Row(
                    children: [
                      Icon(Icons.money, size: 14, color: Colors.green),
                      SizedBox(width: width * 0.020),
                      CustomText(
                        text:
                            selectedPaymentMethod, // Display selected payment method
                        fontSize: 12,
                      ),
                      Spacer(),
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.darkBlueShade,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: width * 0.010), // Spacer between containers

        Container(
          height: height * 0.086,
          width: width * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.lightGrey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wallet,
                        size: 14,
                        color: AppColors.darkBlueShade,
                      ),
                      SizedBox(width: width * 0.020),
                      CustomText(
                        text: "Use wallet",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: Switch(
                      activeColor: AppColors.darkBlueShade,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
