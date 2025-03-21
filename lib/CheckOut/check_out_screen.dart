import 'package:flutter/material.dart';
import 'package:date_picker_timetable/date_picker_timetable.dart';
import 'package:untitled2/AppColors/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key, required Map<String, int> selectedServices}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DateTime _selectedDate = DateTime(2025, 3, 24);
  String _selectedTime = "9:00 AM";

  final List<String> timeSlots = [
    "9:00\nAM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM"
  ];

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
                Text("Selected schedule",),
                SizedBox(width: 4,),
                Text("$_selectedTime, ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                    style: TextStyle(color: AppColors.darkBlueShade)),
              ],
            ),

            SizedBox(height: 10),
            DatePicker(
              DateTime(2025, 3, 21),
              width: 60,
              height: 90,
              initialSelectedDate: _selectedDate,
              selectionColor: Colors.blueAccent.shade100,
              selectedTextColor: AppColors.darkBlueShade,
              daysCount: 6,
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            SizedBox(height: 20),
            Text("Select Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTime = timeSlots[index];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _selectedTime == timeSlots[index]
                            ? Colors.blueAccent.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          timeSlots[index],
                          style: TextStyle(
                            color: _selectedTime == timeSlots[index] ? AppColors.darkBlueShade : Colors.black,
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
            Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Azeem Boys Hostel Johar View Lahore Punjab, Johar View, Lahore",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Services list", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildServiceItem("AC Dismounting", "Per AC (1 to 2.5 tons)", "Rs. 1200", "Rs. 1000", 4.8),
            _buildServiceItem("AC General Service", "Per AC (1 to 2.5 tons)", "Rs. 3500", "Rs. 1850", 4.3),
            SizedBox(height: 20),
            Text("Payment method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildServiceItem(String title, String description, String originalPrice, String discountedPrice, double rating) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(description, style: TextStyle(fontSize: 14)),
            SizedBox(height: 10),
            Row(
              children: [
                Text(originalPrice, style: TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough)),
                SizedBox(width: 10),
                Text(discountedPrice, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text("$rating", style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}