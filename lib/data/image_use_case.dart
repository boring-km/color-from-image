import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:color_picker/ui/colors.dart';
import 'package:color_picker/ui/image_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;

class ImageUseCase {
  static Future<lib.Image> getImageFrom(File originalFile) async {
    final bytes = await _getImageBytes(originalFile);
    final List<int> values = bytes.buffer.asUint8List();
    final image = lib.decodeImage(values)!;
    return image;
  }

  static Future<Uint8List> _getImageBytes(File file) async {
    // ignore: avoid_slow_async_io
    if (await file.exists()) {
      final imageBytes = await file.readAsBytes();
      return imageBytes;
    } else {
      return Uint8List(0);
    }
  }

  static List<Color> getPixelImage(lib.Image image, int pixel) {
    final width = image.width;
    final pixelHeight = getHeight(image, pixel);

    final colors = <Color>[];
    final chunk = width ~/ (pixel + 1);

    for (var y = 0; y < pixelHeight; y++) {
      for (var x = 0; x < pixel; x++) {
        final p = image.getPixel(x * chunk, y * chunk);
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
    PixelPainter(colors: colors, xCount: xCount, yCount: yCount).paint(canvas, size);
  }

  static Size _getPixelImageSize(int xCount, int yCount) {
    final pixel = _getPixelWidth(xCount, yCount);
    return Size(xCount * pixel, yCount * pixel);
  }

  static double _getPixelWidth(int xCount, int yCount) {
    final screenWidth = Get.context?.size?.width ?? 390.0;
    final screenHeight = Get.context?.size?.height ?? 800.0;
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
