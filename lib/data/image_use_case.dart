import 'dart:io';

import 'dart:typed_data';
import 'package:color_picker/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as lib;

class ImageUseCase {
  static lib.Image getImageFrom(File originalFile) {
    Uint8List bytes = _getImageBytes(originalFile);
    List<int> values = bytes.buffer.asUint8List();
    final lib.Image image = lib.decodeImage(values)!;
    return image;
  }

  static Uint8List _getImageBytes(File file) {
    if (file.existsSync()) {
      var imageBytes = file.readAsBytesSync();
      return imageBytes;
    } else {
      return Uint8List(0);
    }
  }

  static Future<List<Color>> getPixelImage(int pixel, File originalFile) async {
    var image = getImageFrom(originalFile);
    var width = image.width;
    var pixelHeight = getHeight(pixel, originalFile);

    final colors = <Color>[];
    final chunk = width ~/ (pixel + 1);

    for (int y = 1; y < pixelHeight + 1; y++) {
      for (int x = 1; x < pixel + 1; x++) {
        int p = image.getPixel(x * chunk, y * chunk);
        colors.add(abgrToColor(p));
      }
    }
    return colors;
  }

  static getImageSizeString(int pixel, File originalFile) {
    final image = getImageFrom(originalFile);
    return 'width: $pixel, height: ${(pixel * (image.height / image.width)).toInt()}';
  }

  static int getHeight(int pixel, File originalFile) {
    final image = getImageFrom(originalFile);
    return (pixel * (image.height / image.width)).toInt();
  }

}