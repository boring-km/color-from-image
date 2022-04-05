import 'dart:io';

import 'package:color_picker/data/get_divisors.dart';
import 'package:color_picker/data/image_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PickerViewModel extends GetxController {
  List<Color> colors = <Color>[];
  List<int> pixelWidthList = <int>[];

  int pixelWidth = 1;
  int pixelHeight = 1;

  final TextEditingController pixelInputController = TextEditingController();
  File get _imageFile => File(Get.arguments['path'] as String? ?? '');
  String imageSizeString = '';

  @override
  void onInit() {
    super.onInit();
    pixelWidth = _initialPixelWidth();
    showPixels(pixelWidth);
  }

  _initialPixelWidth() => _setImageWidth() ~/ 4;

  _setImageWidth() {
    int imageWidth = ImageUseCase.getImageFrom(_imageFile).width;
    pixelWidthList = GetDivisors.by(imageWidth);
    return imageWidth;
  }

  showPixels(int selectedPixel) async {
    pixelWidth = selectedPixel - 1;
    colors = await ImageUseCase.getPixelImage(pixelWidth, _imageFile);
    pixelHeight = ImageUseCase.getHeight(pixelWidth, _imageFile);
    imageSizeString = ImageUseCase.getImageSizeString(pixelWidth, _imageFile);
    update();
  }

}
