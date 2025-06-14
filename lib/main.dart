import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'dart:html' as html;
import 'Splash/splash_screen.dart';
import 'google_map/map_screen.dart';

void main() {
  // Register a custom view for the map
  ui.platformViewRegistry.registerViewFactory(
    'google-map-view',
        (int viewId) {
      final mapDiv = html.DivElement()
        ..id = 'google_map_div'
        ..style.width = '100%'
        ..style.height = '100%';

      return mapDiv;
    },
  );

  runApp(MyApp());
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


