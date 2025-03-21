import 'package:flutter/material.dart';
import 'package:date_picker_timetable/date_picker_timetable.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/BottomNavigation/Home/ViewAllServices/home_services_screen.dart';
import 'package:untitled2/CheckOut/peament_method.dart';
import 'package:untitled2/widgets/custom_text.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, int> selectedServices;

  const CheckoutScreen({Key? key, required this.selectedServices}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int count = 0;
  bool isChecked = false;
  DateTime? _selectedDate;
  String? _selectedTime;
  int? _selectedIndex;
  String _address = "Azeem Boys Hostel Johar View Lahore Punjab, Johar View, Lahore"; // Default address

  final List<String> timeSlots = [
    "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"
  ];

  // List of cities and their addresses
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

  void _editAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 500,
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
                          borderRadius: BorderRadius.circular(15), // Customize radius
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
              height: height * 0.12,
              width: width,
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
                    _selectedDate = date; // Update selected date
                    _selectedTime = null; // Reset selected time when date changes
                    _selectedIndex = null; // Reset selected index
                  });
                },
              ),
            ),
            SizedBox(height: 20),

            // Show time slots only if a date is selected
            if (_selectedDate != null) ...[
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
                              ? Colors.blueAccent.shade100 // Highlight if selected
                              : Colors.transparent, // No highlight if not selected
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            timeSlots[index],
                            style: TextStyle(
                              color: _selectedIndex == index
                                  ? AppColors.darkBlueShade // Change text color if selected
                                  : Colors.black, // Default text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
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
            SizedBox(height: 20),

            Text("Services list", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildServiceItem("AC Dismounting", "Per AC (1 to 2.5 tons)", "Rs. 1200", "Rs. 1000", 4.8),
            SizedBox(height: 20),
            PaymentMethod(),
            // Payment Method
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.money, color: Colors.green),
                SizedBox(width: 10),
                Text("Cash", style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.blue),
                SizedBox(width: 10),
                Text("Use wallet", style: TextStyle(fontSize: 16)),
              ],
            ),
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

  // Service Item Widget
  Widget _buildServiceItem(String title, String description, String originalPrice, String discountedPrice, double rating) {
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
                  Text(description, style: TextStyle(fontSize: 14,color: AppColors.darkBlueShade)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(originalPrice, style: TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough,color: AppColors.darkBlueShade)),
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
                      count == 0
                          ? SizedBox(
                        height: height * 0.040,
                        width: width * 0.2210,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => count++);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.add, color: Colors.white, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                "ADD",
                                style: TextStyle(
                                  color: AppColors.whiteTheme,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        height: height * 0.040,
                        width: width * 0.250,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.blueColor, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (count > 0) {
                                  setState(() => count--);
                                  if (count == 0) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeServicesScreen()));
                                  }
                                }
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: height * 0.042,
                                width: width * 0.072,
                                decoration: BoxDecoration(
                                  color: AppColors.blueColor,
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
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: height * 0.042,
                                width: width * 0.072,
                                decoration: BoxDecoration(
                                  color: AppColors.blueColor,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}