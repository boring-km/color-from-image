import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;

class PickerViewModel extends GetxController {

  RxList<Color> colors = <Color>[].obs;
  var numberOfRealPixels = 32;
  static const numberOfSpecialColors = 32;

  RxList<Color> sortedColors = <Color>[].obs;

  var originalImageFile = ''.obs;


  @override
  void onInit() {
    getOriginalImage();
    getPixelImage();
    super.onInit();
  }

  Uint8List getOriginalImage() {
    var filePath = Get.arguments['path'] as String? ?? '';
    originalImageFile = File(filePath).path.obs;
    var imageBytes = File(filePath).readAsBytesSync();
    return imageBytes;
  }

  void getPixelImage() {
    var filePath = Get.arguments['path'] as String? ?? '';
    if (filePath.isEmpty) return;

    Uint8List bytes = getOriginalImage();

    List<int> values = bytes.buffer.asUint8List();
    final image = lib.decodeImage(values)!;

    List<int> pixels = [];

    int? width = image.width;
    int? height = image.height;

    int xChunk = width~/ (numberOfRealPixels + 1);
    int yChunk = height~/ (numberOfRealPixels + 1);

    for (int j = 1; j < numberOfRealPixels + 1; j++) {
      for (int i = 1; i < numberOfRealPixels + 1; i++) {
        int pixel = image.getPixel(xChunk * i, yChunk * j);
        pixels.add(pixel);
        colors.add(abgrToColor(pixel));
      }
    }
  }

  Color abgrToColor(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return Color((argbColor & 0xFF00FF00) | (b << 16) | r);
  }

  int parseUint32(String temp, int number) {

    return (int.parse(temp) >> number) & 0xff;
  }

  List<Color> sortColors(List<Color> colors) {
    List<Color> sorted = [];

    sorted.addAll(colors);
    sorted.sort((a, b) => b.computeLuminance().compareTo(a.computeLuminance()));

    return sorted;
  }

  Color getAverageColor(List<Color> colors) {
    int r = 0, g = 0, b = 0;

    for (int i = 0; i < colors.length; i++) {
      r += colors[i].red;
      g += colors[i].green;
      b += colors[i].blue;
    }

    r = r ~/ colors.length;
    g = g ~/ colors.length;
    b = b ~/ colors.length;

    return Color.fromRGBO(r, g, b, 1);
  }

}