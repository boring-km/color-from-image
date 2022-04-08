import 'dart:io';

import 'package:color_picker/data/get_divisors.dart';
import 'package:color_picker/data/image_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;

class PickerViewModel extends GetxController {
  List<Color> colors = <Color>[];
  List<int> _pixelWidthList = <int>[];

  int pixelWidth = 1;
  int pixelHeight = 1;
  int _pixelIndex = 0;

  File get _imageFile => File(Get.arguments['path'] as String? ?? '');
  late Future<lib.Image> image;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      image = ImageUseCase.getImageFrom(_imageFile);
      pixelWidth = _initialPixelWidth(await image);
      showPixels(pixelWidth);
    });
    // Future.delayed(const Duration(microseconds: 100), () { isFirst = false.obs; update(); });
  }

  int _initialPixelWidth(lib.Image image) => _setImageWidth(image) + 1;

  int _setImageWidth(lib.Image image) {
    int imageWidth = image.width;
    _pixelWidthList = GetDivisors.by(imageWidth);
    return _pixelWidthList[_pixelIndex++];
  }

  showPixels(int selectedPixel) async {
    pixelWidth = selectedPixel - 1;
    final lib.Image img = await image;
    colors = ImageUseCase.getPixelImage(img, pixelWidth, _imageFile);
    pixelHeight = ImageUseCase.getHeight(img, pixelWidth, _imageFile);
    update();
  }

  bool hasNext() => _pixelIndex + 1 < _pixelWidthList.length;

  Null Function() get showNext => () {
        if (hasNext()) {
          showPixels(_pixelWidthList[++_pixelIndex]);
        }
      };

  hasBefore() => 0 < _pixelIndex;

  Null Function() get showBefore => () {
        if (hasBefore()) {
          showPixels(_pixelWidthList[--_pixelIndex]);
        }
      };
}
