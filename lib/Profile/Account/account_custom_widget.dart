import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../AppColors/app_colors.dart';

class ProfileInfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool editable;
  final bool isNavigation;

  const ProfileInfoTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.editable = false,
    this.isNavigation = false,
  });

  void _showEditBottomSheet(BuildContext context) {
    TextEditingController editController = TextEditingController(
      text: subtitle,
    );
    showModalBottomSheet(
      context: context,
      builder: (context) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: height * 0.300,
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit $title",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: editController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.lightGrey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.lightWhite,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.lightWhite,
                        width: 1,
                      ),
                    ),
                    hintText: "Enter phone number",
                  ),
                ),

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing:
              editable
                  ? GestureDetector(
                    onTap: () => _showEditBottomSheet(context),
                    child: const Icon(Icons.edit, size: 18),
                  )
                  : isNavigation
                  ? const Icon(Icons.arrow_forward_ios, size: 16)
                  : null,
        ),
        Divider(thickness: 2),
      ],
    );
  }
}
