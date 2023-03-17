import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'google_map.dart';
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home:   GoogleMapWidget(
          initialCameraPosition: LatLng(14.280577795, 101.31266547000001))
      // GoogleMapWebSiteWidget(
      //     initialCameraPosition: LatLng(14.280577795, 101.31266547000001)),
    );
  }
}
