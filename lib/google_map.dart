import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'kmz_loader.dart';
import 'tile_provider.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng initialCameraPosition;
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  GoogleMapWidget({
    Key? key,
    required this.initialCameraPosition,
  }) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _controller;
  final kmzLoader = KMZLoader();
  final List<double> bounds = [
    101.27987495,
    14.24412514,
    101.34545599,
    14.31703045
  ];

  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _createPolylines();
  }

  @override
  Widget build(BuildContext context) {
    final initialCameraPosition = CameraPosition(
      target: _calculateBoundsCenter(bounds),
      zoom: 14,
    );

    final marker = Marker(
      markerId: MarkerId('myMarker'),
      position: _calculateBoundsCenter(bounds),
      infoWindow: InfoWindow(title: 'My Marker'),
    );

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  //markers: {marker},
                  tileOverlays: _createTileOverlays(),
                  polylines: _polylines,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createPolylines() async {
    String fileName = '20220517_ky_map_block13_flight1_kml.kmz';
    print('create line');
    final data = await kmzLoader.loadKMZ(
        context, fileName);
    setState(() {
      _polylines = data;
    });
  }
  // Set<Polyline> _createPolylines()  {
  //   var polylines = <Polyline>{};
  //   print('create polyline');
  //   // Create initial polyline
  //   var initPolyline = Polyline(
  //     polylineId: PolylineId('initial_polyline'),
  //     points: [
  //       LatLng(14.2805734, 101.3126651),
  //       LatLng(14.280574, 101.312666),
  //       LatLng(14.280575, 101.312666),
  //       LatLng(14.280577, 101.312667),
  //       LatLng(14.280578, 101.312666),
  //       LatLng(14.280579, 101.312665),
  //       LatLng(14.280580, 101.312664),
  //       LatLng(14.280580, 101.312663),
  //     ],
  //     color: Colors.blue,
  //     width: 10,
  //   );
  //   polylines.add(initPolyline);

  //   print(polylines);

  //   return polylines;
  // }
}

Set<TileOverlay> _createTileOverlays() {
  return <TileOverlay>[
    TileOverlay(
      tileOverlayId: TileOverlayId('myTileOverlay'),
      tileProvider: _createTileProvider(),
      fadeIn: true,
      visible: true,
    ),
  ].toSet();
}

TileProvider _createTileProvider() {
  final directoryName = 'assets/tiles';
  return DirectoryTileProvider(directoryName);
}

LatLng _calculateBoundsCenter(List<double> bounds) {
  final swLat = bounds[1];
  final swLng = bounds[0];
  final neLat = bounds[3];
  final neLng = bounds[2];

  final centerLat = (swLat + neLat) / 2;
  final centerLng = (swLng + neLng) / 2;
  print('Test lating $centerLat, $centerLng');

  return LatLng(centerLat, centerLng);
}
