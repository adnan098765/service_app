// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart' as gmaps;
// import 'dart:html' as html;
// import 'map_web.dart';
//
// class WebMap extends StatefulWidget {
//   final double lat;
//   final double lng;
//
//   const WebMap({super.key, required this.lat, required this.lng});
//
//   @override
//   State<WebMap> createState() => _WebMapState();
// }
//
// class _WebMapState extends State<WebMap> {
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final center = gmaps.LatLng(widget.lat, widget.lng);
//       final options = gmaps.MapOptions()
//         ..zoom = 15
//         ..center = center;
//
//       final mapDiv = html.document.getElementById('google_map_div');
//       if (mapDiv != null) {
//         gmaps.GMap(mapDiv, options); // ✅ Constructor for Google Map
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       height: 400,
//       width: double.infinity,
//       child: HtmlElementView(viewType: 'google-map-view'),
//     );
//   }
// }
//
// class GMap {
// }
