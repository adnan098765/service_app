import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class QuantitySelector extends StatefulWidget {
  final int count;
  final Function(int) onQuantityChanged;

  const QuantitySelector({super.key, required this.count, required this.onQuantityChanged});

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.040,
      width: width * 0.250,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.buttonColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.count > 0) {
                widget.onQuantityChanged(widget.count - 1);
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: height * 0.042,
              width: width * 0.072,
              decoration: BoxDecoration(color: AppColors.buttonColor, borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.remove, color: Colors.white, size: 20),
            ),
          ),
          SizedBox(width: width * 0.029),
          Text('${widget.count}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Spacer(),
          InkWell(
            onTap: () {
              widget.onQuantityChanged(widget.count + 1);
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: height * 0.042,
              width: width * 0.072,
              decoration: BoxDecoration(color: AppColors.buttonColor, borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
