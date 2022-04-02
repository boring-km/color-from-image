import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/core/logger.dart';
import 'package:color_picker/core/math.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;

class PickerViewModel extends GetxController {
  RxList<Color> colors = <Color>[].obs;
  int pixelWidthCount = 128;
  int pixelHeightCount = 1;
  RxList<Color> sortedColors = <Color>[].obs;
  RxString originalImageFile = ''.obs;
  bool isPixelShow = false;
  String colorInfo = '';
  RxString showButtonText = 'Show Pixels'.obs;
  int selectedIndex = -1;
  Color selectedColor = Colors.white;

  File get originalFile => File(Get.arguments['path'] as String? ?? '');
  final pixelInputController = TextEditingController();
  String imageSizeString = '';

  @override
  void onInit() {
    super.onInit();

    _setImageWidth();
    showPixelImages();
  }

  void _setImageWidth() {
    // TODO 초기 값 다시 지정 필요함
    // lib.Image image = _getImageFromFile();
    // pixelWidthCount = image.width;
    pixelInputController.text = '$pixelWidthCount';
  }

  showPixelImages() async {
    await _getPixelImage();
    await _changeShowStateAfter500milliseconds();
  }

  _getPixelImage() async {
    lib.Image image = _getImageFromFile();

    int? width = image.width;
    int? height = image.height;

    pixelHeightCount = (pixelWidthCount * (height / width)).toInt();

    int chunk = width ~/ (pixelWidthCount + 1);

    colors.clear();

    Log.i('width: $pixelWidthCount, height: $pixelHeightCount');

    for (int y = 1; y < pixelHeightCount + 1; y++) {
      for (int x = 1; x < pixelWidthCount + 1; x++) {
        int pixel = image.getPixel(x * chunk, y * chunk);
        colors.add(abgrToColor(pixel));
      }
    }
  }

  lib.Image _getImageFromFile() {
    Uint8List bytes = _getImageBytes(originalFile);
    List<int> values = bytes.buffer.asUint8List();
    final lib.Image image = lib.decodeImage(values)!;
    return image;
  }

  Uint8List _getImageBytes(File file) {
    if (file.existsSync()) {
      var imageBytes = file.readAsBytesSync();
      return imageBytes;
    } else {
      return Uint8List(0);
    }
  }

  Color abgrToColor(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = (argbColor & 0xFF) << 16;
    int g = argbColor & 0xFF00FF00;
    return Color(r | g | b);
  }

  Future<void> _changeShowStateAfter500milliseconds() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      isPixelShow = !isPixelShow;
      update();
    });
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

  void Function(String numberString) setPixelCount() {
    return (String numberString) {
      int pixel = int.parse(numberString);
      pixelWidthCount = pixel;
      update();
    };
  }
}
