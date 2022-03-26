import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/core/math.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;

class PickerViewModel extends GetxController {
  RxList<Color> colors = <Color>[].obs;
  var pixelWidthCount = 64;
  var pixelHeightCount = 1.obs;

  RxList<Color> sortedColors = <Color>[].obs;

  var originalImageFile = ''.obs;
  var isOriginalImageVisible = true;
  var isPixelShow = false;

  String colorInfo = '';
  var showButtonText = 'Show Pixels'.obs;

  int selectedIndex = -1;

  Color selectedColor = Colors.white;

  @override
  void onInit() {
    getOriginalImage();
    super.onInit();
  }

  Uint8List getOriginalImage() {
    var filePath = Get.arguments['path'] as String? ?? '';
    var file = File(filePath);
    originalImageFile = file.path.obs;
    if (file.existsSync()) {
      var imageBytes = file.readAsBytesSync();
      return imageBytes;
    } else {
      return Uint8List(0);
    }
  }

  getPixelImage() async {
    var filePath = Get.arguments['path'] as String? ?? '';
    if (filePath.isEmpty) return;

    Uint8List bytes = getOriginalImage();

    List<int> values = bytes.buffer.asUint8List();
    final image = lib.decodeImage(values)!;

    List<int> pixels = [];

    int? width = image.width;
    int? height = image.height;

    pixelHeightCount = (pixelWidthCount * (height / width)).toInt().obs;

    int xChunk = width ~/ (pixelWidthCount + 1);
    int yChunk = height ~/ (pixelHeightCount.value + 1);

    colors.clear();
    for (int j = 1; j < pixelHeightCount.value + 1; j++) {
      for (int i = 1; i < pixelWidthCount + 1; i++) {
        int pixel = image.getPixel(xChunk * i, yChunk * j);
        pixels.add(pixel);
        colors.add(abgrToColor(pixel));
      }
    }
  }

  Color abgrToColor(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = (argbColor & 0xFF) << 16;
    int g = argbColor & 0xFF00FF00;
    return Color(r | g | b);
  }

  showPixelImages() async {
    changeButtonText();
    getPixelImage();
    changeShowStateAfter500milliseconds();
  }

  Future<void> changeShowStateAfter500milliseconds() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      isPixelShow = !isPixelShow;
      update();
    });
  }

  changeButtonText() {
    isOriginalImageVisible = !isOriginalImageVisible;
    showButtonText =
        isOriginalImageVisible ? 'Show Pixels'.obs : 'Show Original'.obs;
    update();
  }

  getColorInfo(int index) {
    selectedIndex = index;
    selectedColor = colors[index];

    colorInfo = 'R: ${hex(selectedColor.red)},'
        ' G: ${hex(selectedColor.green)},'
        ' B: ${hex(selectedColor.blue)},'
        ' A: ${hex(selectedColor.alpha)}';
    update();
  }

  isSelectedIndex(int index) => index == selectedIndex;
}
