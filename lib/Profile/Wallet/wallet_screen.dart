import 'package:flutter/material.dart';
import 'package:untitled2/AppColors/app_colors.dart';
import 'package:untitled2/widgets/custom_text.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        title: CustomText(text: "Wallet",fontSize: 20,),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        height: height*0.20,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Available Credits",color: AppColors.whiteTheme,),
              SizedBox(height: height*0.038,),
              CustomText(text: "Off/on",color:AppColors.whiteTheme,),
              Row(
                children: [
                  Switch(
                    activeColor: AppColors.lightGrey,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  Spacer(),
                  CustomText(text: "PKR0",fontSize: 24,fontWeight: FontWeight.bold,color: AppColors.whiteTheme,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
