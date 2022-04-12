import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/core/logger.dart';
import 'package:color_picker/data/get_divisors.dart';
import 'package:color_picker/data/image_use_case.dart';
import 'package:color_picker/presentation/picker/image_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;

import 'package:permission_handler/permission_handler.dart';

class PickerViewModel extends GetxController {
  List<Color> colors = <Color>[];
  List<int> _pixelWidthList = <int>[];

  int pixelWidth = 1;
  int pixelHeight = 1;
  int _pixelIndex = 0;

  GlobalKey saveKey = GlobalKey();

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
    Future.delayed(const Duration(milliseconds: 300), () => update());
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

  get savePicture => () async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    var size = saveKey.currentContext?.size;
    Canvas canvas = Canvas(recorder);
    var painter = PixelPainter(colors: colors, xCount: pixelWidth, yCount: pixelHeight);
    painter.paint(canvas, size!);

    ui.Image rendered = await recorder.endRecording().toImage(size.width.floor(), size.height.floor());
    var pngBytes = await rendered.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes.buffer.asUint8List()),
        quality: 100,
        name: "pixel_image");

    Log.i(result);
  };
}
