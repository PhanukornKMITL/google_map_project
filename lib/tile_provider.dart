import 'dart:io';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryTileProvider extends TileProvider {
  final String directoryName;

  DirectoryTileProvider(this.directoryName);

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {

    final path = '$directoryName/$zoom/$x/$y.png';
   
    final bytes = await loadImageFromAsset(path);
    // if (bytes == null) print('data not found');
    // else print('found bytes data');
    return decodeImageFromList(bytes).then((image) {
      return image.toByteData(format: ImageByteFormat.png).then((byteData) {
        return Tile(256, 256, byteData!.buffer.asUint8List());
      });
    });
  }

  Future<Uint8List> loadImageFromAsset(String path) async {
  //print('path: $path');
  var data;
  try {
    data = await rootBundle.load(path);
  } catch (e) {
   // print('eeror $e');
  }
  //print('data: $data');
  return data.buffer.asUint8List();
}
}
