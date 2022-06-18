import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:color_picker/presentation/picker/image_painter.dart';
import 'package:color_picker/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  static List<Color> getPixelImage(lib.Image image, int pixel) {
    var width = image.width;
    var pixelHeight = getHeight(image, pixel);

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

  static int getHeight(lib.Image image, int pixel) {
    return (pixel * (image.height / image.width)).toInt();
  }

  static Future<ByteData> getPixelImageBytes(List<Color> colors, int xCount, int yCount) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = _getPixelImageSize(xCount, yCount);
    _drawPixels(colors, xCount, yCount, canvas, size);

    final rendered = await recorder.endRecording().toImage(size.width.floor(), size.height.floor());
    return await rendered.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);
  }

  static void _drawPixels(List<Color> colors, int xCount, int yCount, Canvas canvas, Size size) {
    final painter = PixelPainter(colors: colors, xCount: xCount, yCount: yCount);
    painter.paint(canvas, size);
  }

  static Size _getPixelImageSize(int xCount, int yCount) {
    double pixel = _getPixelWidth(xCount, yCount);
    return Size(xCount * pixel, yCount * pixel);
  }

  static double _getPixelWidth(int xCount, int yCount) {
    double screenWidth = Get.context?.size?.width ?? 390.0;
    double screenHeight = Get.context?.size?.height ?? 800.0;
    var pixel = screenWidth / xCount - 1;
    while (true) {
      pixel += 0.00001;
      if (pixel * xCount > screenWidth || pixel * yCount > screenHeight) {
        pixel -= 0.00001;
        break;
      }
    }
    return pixel;
  }
}
