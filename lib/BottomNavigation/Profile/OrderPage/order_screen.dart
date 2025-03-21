import 'package:flutter/material.dart';
import 'package:untitled2/widgets/custom_text.dart';

class OrderScreenProfile extends StatefulWidget {
  const OrderScreenProfile({super.key});

  @override
  State<OrderScreenProfile> createState() => _OrderScreenProfileState();
}

class _OrderScreenProfileState extends State<OrderScreenProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: CustomText(text: "Order",fontSize: 20,),
      ),
    );
  }
}
