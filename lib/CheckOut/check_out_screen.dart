import 'package:flutter/material.dart';
import 'package:date_picker_timetable/date_picker_timetable.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/CheckOut/peament_method.dart';
import 'package:untitled2/CheckOut/quantity_selector.dart';
import 'package:untitled2/widgets/custom_text.dart';
import '../widgets/custom_container.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, int> selectedServices;

  const CheckoutScreen({super.key, required this.selectedServices});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isChecked = false;
  DateTime? _selectedDate;
  String? _selectedTime;
  int? _selectedIndex;
  String _address =
      "Azeem Boys Hostel Johar View Lahore Punjab, Johar View, Lahore";

  // Time slots will be generated dynamically from 9 AM to 10 PM
  final List<String> timeSlots = _generateTimeSlots();

  final List<Map<String, String>> citiesWithAddresses = [
    {
      "city": "Lahore",
      "area": "Johar View",
      "address": "Azeem Boys Hostel Johar View Lahore Punjab",
    },
    {
      "city": "Karachi",
      "area": "Federal B Area",
      "address":
          "New Mumbai Bakery Masoomeen Road Naseerabad Block 14 Federal B Area Karachi Sindh",
    },
    {
      "city": "Islamabad",
      "area": "F-10",
      "address": "XYZ Hostel, F-10, Islamabad",
    },
  ];

  final Map<String, int> servicePrices = {
    "AC Dismounting": 1000,
    "AC General Service": 1850,
    "AC repairing": 1850,
    "Floor standing cabinet Ac general service": 1850,
  };

  static List<String> _generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 9; hour <= 22; hour++) {
      // Add :00 slot
      slots.add(
        '${hour > 12 ? hour - 12 : hour}:00 ${hour >= 12 ? 'PM' : 'AM'}',
      );

      // Add :30 slot except for 10 PM
      if (hour < 22) {
        slots.add(
          '${hour > 12 ? hour - 12 : hour}:30 ${hour >= 12 ? 'PM' : 'AM'}',
        );
      }
    }
    return slots;
  }

  void _editAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        double height = MediaQuery.of(context).size.height;
        return Container(
          height: height * 0.500,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteTheme,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose address for booking",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.013),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: citiesWithAddresses.length,
                  itemBuilder: (context, index) {
                    final cityData = citiesWithAddresses[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      elevation: 2,
                      child: ListTile(
                        leading: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          activeColor: AppColors.appColor,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        title: Text(
                          "${cityData["city"]} - ${cityData["area"]}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          cityData["address"]!,
                          style: TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          setState(() {
                            _address = cityData["address"]!;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.014),
              CustomText(text: "Add New Address", color: AppColors.appColor),
              SizedBox(height: height * 0.014),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: AppColors.whiteTheme,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _calculateTotalPrice() {
    int total = 0;
    widget.selectedServices.forEach((service, quantity) {
      if (servicePrices.containsKey(service)) {
        total += servicePrices[service]! * quantity;
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = _calculateTotalPrice();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout", style: TextStyle(color: AppColors.whiteTheme)),
        centerTitle: true,
        backgroundColor: AppColors.darkBlueShade,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.whiteTheme),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScheduleSection(),
            SizedBox(height: height * 0.024),
            if (_selectedDate != null) _buildTimeSlotsSection(),
            SizedBox(height: height * 0.024),
            _buildAddressSection(),
            SizedBox(height: height * 0.024),
            Text(
              "Services list",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.014),
            ...widget.selectedServices.entries.map((entry) {
              return ServiceCard(
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
              );
            }),
            SizedBox(height: height * 0.024),
            // PaymentMethod(),
            SizedBox(height: height * 0.014),
            _buildTotalPriceSection(totalPrice),
            SizedBox(height: height * 0.024),
            CustomContainer(
              height: height * 0.060,
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
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final DateTime today = DateTime.now();
    final DateTime endDate = DateTime(today.year, today.month + 2, today.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Selected schedule",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: w * 0.014),
            _selectedDate != null && _selectedTime != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat(
                        'MMMM',
                        'en_US',
                      ).format(_selectedDate!), // English month name
                      style: TextStyle(color: AppColors.appColor, fontSize: 14),
                    ),
                    Text(
                      DateFormat(
                        'EEEE',
                        'en_US',
                      ).format(_selectedDate!), // English day name
                      style: TextStyle(color: AppColors.appColor, fontSize: 12),
                    ),
                    Text(
                      "$_selectedTime, ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                      style: TextStyle(color: AppColors.appColor, fontSize: 12),
                    ),
                  ],
                )
                : Text(
                  "No date/time selected",
                  style: TextStyle(color: Colors.grey),
                ),
          ],
        ),
        SizedBox(height: h * 0.024),
        Container(
          height: h * 0.143,
          width: w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            color: AppColors.whiteTheme,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: DatePicker(
            DateTime.now(),
            width: w * 0.180,
            height: h * 0.090,
            initialSelectedDate: _selectedDate,
            selectionColor: AppColors.appColor,
            selectedTextColor: AppColors.whiteTheme,
            daysCount: endDate.difference(today).inDays + 1,
            dateTextStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            dayTextStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            monthTextStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
                _selectedTime = null;
                _selectedIndex = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotsSection() {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: h * 0.014),
        Container(
          height: h * 0.0750,
          width: w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey300),
            color: AppColors.whiteTheme,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTime = timeSlots[index];
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          _selectedIndex == index
                              ? AppColors.appColor
                              : Colors.transparent,
                      width: 2,
                    ),
                    color:
                        _selectedIndex == index
                            ? AppColors.darkBlueShade.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      timeSlots[index],
                      style: TextStyle(
                        color:
                            _selectedIndex == index
                                ? AppColors.appColor
                                : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    double h = MediaQuery.of(context).size.height;
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
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: Text(_address, style: TextStyle(fontSize: 16))),
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

  Widget _buildTotalPriceSection(int totalPrice) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      color: AppColors.lightGrey,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // List all selected services with their quantities and prices
            ...widget.selectedServices.entries.map((entry) {
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
                  if (entry.key != widget.selectedServices.entries.last.key)
                    Divider(),
                ],
              );
            }),

            Divider(thickness: 2),

            // Total price row
            Row(
              children: [
                CustomText(
                  text: "Total Price",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                Spacer(),
                CustomText(
                  text: "Rs. $totalPrice",
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
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String originalPrice;
  final String discountedPrice;
  final double rating;
  final int count;
  final Function(int) onQuantityChanged;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.rating,
    required this.count,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/images/img.png",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: AppColors.appColor),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        originalPrice,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.appColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        discountedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.appColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.greenColor, size: 16),
                      Text(
                        "$rating",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.greenColor,
                        ),
                      ),
                      Spacer(),
                      QuantitySelector(
                        count: count,
                        onQuantityChanged: onQuantityChanged,
                      ),
                    ],
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
