// import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'dart:html' as html;
import 'package:firebase_core/firebase_core.dart';
import 'Splash/splash_screen.dart';
import 'google_map/map_screen.dart';

void main() async {

  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Register a custom view for the map
  // ui.platformViewRegistry.registerViewFactory(
  //   'google-map-view',
  //       (int viewId) {
  //     final mapDiv = html.DivElement()
  //       ..id = 'google_map_div'
  //       ..style.width = '100%'
  //       ..style.height = '100%';
  //
  //     return mapDiv;
  //   },
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gee Hazir Janab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}