import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/core/logger.dart';
import 'package:color_picker/data/get_divisors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;

class PickerViewModel extends GetxController {
  RxList<Color> colors = <Color>[].obs;
  int pixelWidthCount = 1;
  int pixelHeightCount = 1;
  RxList<Color> sortedColors = <Color>[].obs;
  RxString originalImageFile = ''.obs;
  String colorInfo = '';
  int selectedIndex = -1;
  Color selectedColor = Colors.white;
  List<int> pixelWidthList = <int>[];

  File get originalFile => File(Get.arguments['path'] as String? ?? '');
  final TextEditingController pixelInputController = TextEditingController();
  String imageSizeString = '';

  @override
  void onInit() {
    super.onInit();
    pixelWidthCount = _setImageWidth() ~/ 4;
    showPixelImages(pixelWidthCount);
  }

  _setImageWidth() {
    // TODO 초기 값 다시 지정 필요함
    int pixelWidthCount = _getImageWidthFromFile();
    pixelWidthList = GetDivisors.by(pixelWidthCount);
    return pixelWidthCount;
  }

  int _getImageWidthFromFile() => _getImageFromFile().width;

  showPixelImages(int pixel) async {
    pixelWidthCount = pixel - 1;
    await _getPixelImage(pixelWidthCount);
    update();
  }

  _getPixelImage(int pixel) async {
    lib.Image image = _getImageFromFile();

    int? width = image.width;
    int? height = image.height;

    Log.i('image size: $width x $height');

    pixelHeightCount = (pixel * (height / width)).toInt();

    int chunk = width ~/ (pixel + 1);

    colors.clear();
    imageSizeString = 'width: $pixel, height: $pixelHeightCount';

    Log.i('$imageSizeString, pixel chunk: $chunk');

    for (int y = 1; y < pixelHeightCount + 1; y++) {
      for (int x = 1; x < pixel + 1; x++) {
        int p = image.getPixel(x * chunk, y * chunk);
        colors.add(_abgrToColor(p));
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

  Color _abgrToColor(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = (argbColor & 0xFF) << 16;
    int g = argbColor & 0xFF00FF00;
    return Color(r | g | b);
  }
}
