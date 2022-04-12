import 'dart:io';

import 'dart:typed_data';
import 'package:color_picker/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as lib;

class ImageUseCase {
  static Future<lib.Image> getImageFrom(File originalFile) async {
    Uint8List bytes = await _getImageBytes(originalFile);
    List<int> values = bytes.buffer.asUint8List();
    final lib.Image image = lib.decodeImage(values)!;
    return image;
  }

  static Future<Uint8List> _getImageBytes(File file) async {
    if (await file.exists()) {
      var imageBytes = await file.readAsBytes();
      return imageBytes;
    } else {
      return Uint8List(0);
    }
  }

  static List<Color> getPixelImage(lib.Image image, int pixel, File originalFile) {
    var width = image.width;
    var pixelHeight = getHeight(image, pixel, originalFile);

    final List<Color> colors = <Color>[];
    final chunk = width ~/ (pixel + 1);

    for (int y = 0; y < pixelHeight; y++) {
      for (int x = 0; x < pixel; x++) {
        int p = image.getPixel(x * chunk, y * chunk);
        colors.add(abgrToColor(p));
      }
    }
    return colors;
  }

  static int getHeight(lib.Image image, int pixel, File originalFile) {
    return (pixel * (image.height / image.width)).toInt();
  }

}