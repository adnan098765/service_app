import 'package:flutter/material.dart';
import 'package:date_picker_timetable/date_picker_timetable.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/BottomNavigation/Home/ViewAllServices/home_services_screen.dart';
import 'package:untitled2/CheckOut/peament_method.dart';
import 'package:untitled2/CheckOut/quantity_selector.dart';
import 'package:untitled2/widgets/custom_text.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, int> selectedServices;

  const CheckoutScreen({Key? key, required this.selectedServices}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isChecked = false;
  DateTime? _selectedDate;
  String? _selectedTime;
  int? _selectedIndex;
  String _address = "Azeem Boys Hostel Johar View Lahore Punjab, Johar View, Lahore";

  final List<String> timeSlots = [
    "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"
  ];

  final List<Map<String, String>> citiesWithAddresses = [
    {
      "city": "Lahore",
      "area": "Johar View",
      "address": "Azeem Boys Hostel Johar View Lahore Punjab",
    },
    {
      "city": "Karachi",
      "area": "Federal B Area",
      "address": "New Mumbai Bakery Masoomeen Road Naseerabad Block 14 Federal B Area Karachi Sindh",
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

  void _editAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        double height = MediaQuery.of(context).size.height;
        return Container(
          height: height*0.500,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose address for booking",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: citiesWithAddresses.length,
                  itemBuilder: (context, index) {
                    final cityData = citiesWithAddresses[index];
                    return ListTile(
                      leading: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        activeColor: AppColors.darkBlueShade,
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      title: Text(
                        "${cityData["city"]} - ${cityData["area"]}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              CustomText(text: "Add New Address"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Done"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScheduleSection(),
            SizedBox(height: 20),
            if (_selectedDate != null) _buildTimeSlotsSection(),
            SizedBox(height: 20),
            _buildAddressSection(),
            SizedBox(height: 20),
            Text("Services list", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
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
            }).toList(),
            SizedBox(height: 20),
            PaymentMethod(),
            SizedBox(height: 10),
            _buildTotalPriceSection(totalPrice),
            SizedBox(height: 10),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Place order logic
                },
                child: Text("Place Order", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Selected schedule"),
            SizedBox(width: 6),
            _selectedDate != null && _selectedTime != null
                ? Text(
              "$_selectedTime, ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
              style: TextStyle(color: AppColors.darkBlueShade),
            )
                : Text(
              "No date/time selected",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DatePicker(
            DateTime.now(),
            width: 60,
            height: 90,
            initialSelectedDate: _selectedDate,
            selectionColor: Colors.blueAccent.shade100,
            selectedTextColor: AppColors.darkBlueShade,
            daysCount: 60,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey300),
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
                      color: _selectedIndex == index
                          ? AppColors.blueAccentColor
                          : Colors.transparent,
                      width: 2,
                    ),
                    color: _selectedIndex == index
                        ? Colors.blueAccent.shade100
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      timeSlots[index],
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? AppColors.darkBlueShade
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _address,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: AppColors.blueAccentColor),
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CustomText(text: "Total Price", fontSize: 16),
            Spacer(),
            CustomText(text: "Rs. $totalPrice", fontSize: 16),
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
    Key? key,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.rating,
    required this.count,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.only(bottom: 10),
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
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(description, style: TextStyle(fontSize: 14, color: AppColors.darkBlueShade)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(originalPrice, style: TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough, color: AppColors.darkBlueShade)),
                      SizedBox(width: 10),
                      Text(discountedPrice, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkBlueShade)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.greenColor, size: 16),
                      Text("$rating", style: TextStyle(fontSize: 14, color: AppColors.greenColor)),
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

