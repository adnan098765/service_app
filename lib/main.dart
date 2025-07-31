import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:untitled2/screens/Controlller/add_address_controller.dart';

import 'splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() async {
    final controller = AddAddressController();
    print(
      'main.dart: AddAddressController registered, hashCode: ${controller.hashCode} @ ${DateTime.now().toIso8601String()}',
    );
    await controller.loadSavedAddresses(); // Ensure initialization completes
    return controller;
  }, permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
