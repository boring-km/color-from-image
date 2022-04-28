import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/core/logger.dart';
import 'package:color_picker/core/permissions.dart';
import 'package:color_picker/data/get_divisors.dart';
import 'package:color_picker/data/image_use_case.dart';
import 'package:color_picker/presentation/picker/image_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as lib;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';

class PickerViewModel extends GetxController {
  List<Color> colors = <Color>[];
  List<int> _pixelWidthList = <int>[];

  int pixelWidth = 1;
  int pixelHeight = 1;
  int _pixelIndex = 2;

  File get _imageFile => File(Get.arguments['path'] as String? ?? '');
  late Future<lib.Image> image;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() async {
      image = ImageUseCase.getImageFrom(_imageFile);
      pixelWidth = _initializeWidth(await image);
      showPixels(pixelWidth);
    });
  }

  int _initializeWidth(lib.Image image) {
    int imageWidth = image.width;
    _pixelWidthList = GetDivisors.by(imageWidth);
    return _pixelWidthList[_pixelIndex] + 1;
  }

  showPixels(int selectedPixel) async {
    pixelWidth = selectedPixel - 1;
    final lib.Image img = await image;
    colors = ImageUseCase.getPixelImage(img, pixelWidth);
    pixelHeight = ImageUseCase.getHeight(img, pixelWidth);
    Future.delayed(const Duration(milliseconds: 300), () => update());
  }

  bool hasNext() => _pixelIndex + 1 < _pixelWidthList.length;

  bool hasBefore() => 2 < _pixelIndex;

  String hasNextString() => hasNext() ? '다음' : '끝';

  String hasBeforeString() => hasBefore() ? '이전' : '시작';

  get showNext => () {
        if (hasNext()) {
          showPixels(_pixelWidthList[++_pixelIndex]);
        }
      };

  get showBefore => () {
        if (hasBefore()) {
          showPixels(_pixelWidthList[--_pixelIndex]);
        }
      };

  get savePicture => () async {
        final hasPermission = await checkStoragePermission();
        if (hasPermission) {
          ByteData pngBytes = await _getPixelImageBytes();
          await ImageGallerySaver.saveImage(
            Uint8List.fromList(pngBytes.buffer.asUint8List()),
            quality: 100,
            name: "pixel_image",
            isReturnImagePathOfIOS: true,
          );
        }
      };

  Future<String> getShareFilePath() async {
    final hasPermission = await checkStoragePermission();
    Log.i('hasPermission: $hasPermission');
    if (hasPermission) {
      ByteData pngBytes = await _getPixelImageBytes();
      final Uint8List bytes = Uint8List.fromList(pngBytes.buffer.asUint8List());
      final dir = await getApplicationDocumentsDirectory();
      final filePath = dir.path + '/pixel_temp.jpg';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await file.writeAsBytes(bytes);
      Log.i(filePath);
      return filePath;
    } else {
      return '';
    }
  }

  Future<ByteData> _getPixelImageBytes() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = _getPixelImageSize(pixelWidth, pixelHeight);
    _drawPixels(canvas, size);

    final rendered = await recorder.endRecording().toImage(size.width.floor(), size.height.floor());
    return await rendered.toByteData(format: ui.ImageByteFormat.png) ?? ByteData(0);
  }

  void _drawPixels(Canvas canvas, Size size) {
    final painter = PixelPainter(colors: colors, xCount: pixelWidth, yCount: pixelHeight);
    painter.paint(canvas, size);
  }

  Size _getPixelImageSize(int xCount, int yCount) {
    double pixel = _getPixelWidth(xCount, yCount);
    return Size(pixelWidth * pixel, pixelHeight * pixel);
  }

  double _getPixelWidth(int xCount, int yCount) {
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

  void sharePicture() async {
    final savePath = (await getShareFilePath()).replaceAll('file://', '');
    if (await File(savePath).exists()) {
      Log.i('is exists');
      await Share.shareFiles([savePath], subject: 'Share Your Pixel Image');
      await File(savePath).delete();
    } else {
      Log.e('is not exists');
    }
  }
}
