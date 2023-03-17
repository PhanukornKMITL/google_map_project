import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:archive/archive.dart';
import 'dart:convert';

class KMZLoader {
  Future<Set<Polyline>> loadKMZ(BuildContext context, String filename) async {
    var byteData;

    try {
      byteData = await rootBundle.load('assets/kmz/$filename');
    } catch (e) {
      print('error load kmz $e');
    }

    //print('byteDatas $byteData');
    var kmlString = await _parseKMZ(byteData.buffer.asUint8List());
    //print('kml string $kmlString');

    var doc = XmlDocument.parse(kmlString);
    var polylines = _parsePolylines(doc);

    return polylines;
  }

  Future<String> _parseKMZ(Uint8List bytes) async {
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      if (file.name.endsWith('.kml')) {
        return utf8.decode(file.content);
      }
    }
    throw Exception('No .kml file found in KMZ archive');
  }

  Future<Set<Polyline>> _parsePolylines(XmlDocument doc) async {
    var polylines = <Polyline>{};
    var coords = <LatLng>[];
    //print('kmml XML $doc');

    try {
      for (var pm in doc.findAllElements('Placemark')) {
      
        for (var l in pm.findElements('LineString')) {
          for (var c in l.findElements('coordinates')) {
            var coordStrings = c.text.split(' ');
            //print('coor in xml $coordStrings');
            for (var coordString in coordStrings) {
              var latLngStrings = coordString.split(',');
              if (latLngStrings.length >= 2) {
                var lat = double.parse(latLngStrings[1]);
                var lng = double.parse(latLngStrings[0]);
                coords.add(LatLng(lat, lng));
              } else {
               // print('wrong polyline coordinate $latLngStrings');
              }
            }
          }
        }
        if (coords.isNotEmpty) {
          polylines.add(Polyline(
              polylineId: PolylineId(pm.getElement('name')?.text ?? ''),
              points: coords,
              color: Colors.yellow,
              width: 3));
        }
      }
      //print('Polyline coordinates: $coords');
    } catch (e) {
      print('Error $e');
    }

    return polylines;
  }
}
