import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/data/get_divisors.dart';
import 'package:color_picker/data/image_use_case.dart';
import 'package:color_picker/data/save_use_case.dart';
import 'package:color_picker/data/share_use_case.dart';
import 'package:color_picker/ui/show_simple_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;

class PixelViewModel extends GetxController {
  List<Color> colors = <Color>[];
  List<int> _pixelWidthList = <int>[];

  int pixelWidth = 1;
  int pixelHeight = 1;
  int _pixelIndex = 2;

  Uint8List imageBytes = Uint8List(0);

  File get _imageFile => File(Get.arguments['path'] as String? ?? '');
  late Future<lib.Image> image;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      image = ImageUseCase.getImageFrom(_imageFile);
      pixelWidth = _initializeWidth(await image);
      await _showPixels(pixelWidth);
    });
  }

  int _initializeWidth(lib.Image image) {
    final imageWidth = image.width;
    _pixelWidthList = GetDivisors.by(imageWidth);
    return _pixelWidthList[_pixelIndex];
  }

  Future<void>_showPixels(int selectedPixel) async {
    pixelWidth = selectedPixel - 1;
    final img = await image;
    colors = ImageUseCase.getPixelImage(img, pixelWidth);
    pixelHeight = ImageUseCase.getHeight(img, pixelWidth);
    imageBytes = await getPicture();
    Future.delayed(const Duration(milliseconds: 300), update);
  }

  bool hasNext() => _pixelIndex + 1 < _pixelWidthList.length;

  bool hasBefore() => 2 < _pixelIndex;

  String hasNextString() => hasNext() ? 'Next' : 'Last';

  String hasBeforeString() => hasBefore() ? 'Prev' : 'First';

  Null Function() get showNext => () {
        if (hasNext()) {
          _showPixels(_pixelWidthList[++_pixelIndex]);
        }
      };

  Null Function() get showBefore => () {
        if (hasBefore()) {
          _showPixels(_pixelWidthList[--_pixelIndex]);
        }
      };

  Future<void> Function() get savePicture => () async {
        final pngBytes = await ImageUseCase.getPixelImageBytes(colors, pixelWidth, pixelHeight);
        final resultMessage = await SaveUseCase.save(pngBytes);
        showSimpleAlert(resultMessage);
      };

  Future<void> sharePicture() async {
    final pngBytes = await ImageUseCase.getPixelImageBytes(colors, pixelWidth, pixelHeight);
    await ShareUseCase.share(pngBytes);
  }

  Future<Uint8List> getPicture() async {
    final pngBytes = await ImageUseCase.getPixelImageBytes(colors, pixelWidth, pixelHeight);
    return Uint8List.fromList(pngBytes.buffer.asUint8List());
  }

  String get getSizeText => '$pixelWidth x $pixelHeight';
}
