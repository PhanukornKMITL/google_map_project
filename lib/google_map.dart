import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'kmz_loader.dart';
import 'tile_provider.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng initialCameraPosition;

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
    final data = await kmzLoader.loadKMZ(context, fileName);
    setState(() {
      _polylines = data;
    });
  }
}

Set<TileOverlay> _createTileOverlays() {
  print('WtF!');
  var tile = <TileOverlay>[
    TileOverlay(
      tileOverlayId: const TileOverlayId('myTileOverlay'),
      tileProvider: _createTileProvider(),
      fadeIn: true,
      visible: true,
    ),
  ].toSet();

  print(tile);
  return tile;
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
