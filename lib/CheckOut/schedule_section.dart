import 'package:flutter/material.dart';
import 'package:date_picker_timetable/date_picker_timetable.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/AppColors/app_colors.dart';

class ScheduleSection extends StatefulWidget {
  final DateTime? selectedDate;
  final String? selectedTime;
  final Function(DateTime) onDateSelected;
  final Function(String) onTimeSelected;

  const ScheduleSection({
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  _ScheduleSectionState createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  int? _selectedIndex;
  final List<String> timeSlots = _generateTimeSlots();

  static List<String> _generateTimeSlots() {
    List<String> slots = [];
    for (int hour = 9; hour <= 22; hour++) {
      slots.add(
        '${hour > 12 ? hour - 12 : hour}:00 ${hour >= 12 ? 'PM' : 'AM'}',
      );
      if (hour < 22) {
        slots.add(
          '${hour > 12 ? hour - 12 : hour}:30 ${hour >= 12 ? 'PM' : 'AM'}',
        );
      }
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final endDate = DateTime(today.year, today.month + 2, today.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Selected schedule",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            widget.selectedDate != null && widget.selectedTime != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMMM', 'en_US').format(widget.selectedDate!),
                  style: TextStyle(color: AppColors.appColor, fontSize: 14),
                ),
                Text(
                  DateFormat('EEEE', 'en_US').format(widget.selectedDate!),
                  style: TextStyle(color: AppColors.appColor, fontSize: 12),
                ),
                Text(
                  "${widget.selectedTime}, ${widget.selectedDate!.day}-${widget.selectedDate!.month}-${widget.selectedDate!.year}",
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
        SizedBox(height: 16),
        Container(
          height: 120,
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
            width: 60,
            height: 80,
            initialSelectedDate: widget.selectedDate,
            selectionColor: AppColors.appColor,
            selectedTextColor: AppColors.whiteTheme,
            daysCount: endDate.difference(today).inDays + 1,
            onDateChange: widget.onDateSelected,
          ),
        ),
        if (widget.selectedDate != null) _buildTimeSlots(),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      children: [
        SizedBox(height: 16),
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            color: AppColors.whiteTheme,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onTimeSelected(timeSlots[index]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedIndex == index
                          ? AppColors.appColor
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      timeSlots[index],
                      style: TextStyle(
                        color: _selectedIndex == index
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
}