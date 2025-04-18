import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/CheckOut/service_card.dart';
import 'package:untitled2/CheckOut/total_price.dart';
import 'package:untitled2/CheckOut/schedule_section.dart';
import 'package:untitled2/widgets/custom_container.dart';
import 'package:untitled2/widgets/custom_text.dart';
import 'address_selection.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, int> selectedServices;

  const CheckoutScreen({super.key, required this.selectedServices});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  String _address = "Azeem Boys Hostel Johar View Lahore Punjab";

  final Map<String, int> servicePrices = {
    "AC Dismounting": 1000,
    "AC General Service": 1850,
    "AC repairing": 1850,
    "Floor standing cabinet Ac general service": 1850,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: AppColors.whiteTheme)),
        centerTitle: true,
        backgroundColor: AppColors.darkBlueShade,
        iconTheme: IconThemeData(color: AppColors.whiteTheme),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScheduleSection(
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  _selectedTime = null;
                });
              },
              onTimeSelected: (time) {
                setState(() => _selectedTime = time);
              },
            ),
            SizedBox(height: 24),
            _buildAddressSection(),
            SizedBox(height: 24),
            Text(
              "Services list",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...widget.selectedServices.entries.map((entry) => ServiceCard(
              title: entry.key,
              description: "Per AC (1 to 2.5 tons)",
              originalPrice: "Rs. 1200",
              discountedPrice: "Rs. 1000",
              rating: 4.8,
              count: entry.value,
              onQuantityChanged: (newCount) {
                setState(() {
                  widget.selectedServices[entry.key] = newCount;
                  if (newCount == 0) {
                    widget.selectedServices.remove(entry.key);
                  }
                });
              },
            )),
            SizedBox(height: 24),
            TotalPriceCard(
              selectedServices: widget.selectedServices,
              servicePrices: servicePrices,
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                // You can add the order placement logic here
              },
              child: CustomContainer(
                height: 60,
                width: double.infinity,
                color: AppColors.darkBlueShade,
                borderRadius: 15,
                child: Center(
                  child: CustomText(
                    text: "Place Order",
                    color: AppColors.whiteTheme,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            color: AppColors.whiteTheme,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_address, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Text(
                      "Tap edit to change address",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.darkBlueShade),
                onPressed: _editAddress,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddressSelectionSheet(
        currentAddress: _address,
        onSelectAddress: (address) {
          setState(() {
            _address = address;
          });
        }, savedAddresses: [], onAddNewAddress: () {  },
      ),
    );
  }
}
