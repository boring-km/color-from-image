import 'package:color_picker/core/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PixelPainter extends CustomPainter {

  PixelPainter({
    required this.colors,
    required this.xCount,
    required this.yCount,
  });
  final List<Color> colors;
  final int xCount;
  final int yCount;
  double pixel = 0;

  @override
  void paint(Canvas canvas, Size size) {
    if (colors.isEmpty) {
      return;
    }

    final screenWidth = Get.context?.size?.width ?? 390.0;
    final screenHeight = Get.context?.size?.height ?? 800.0;
    if (screenWidth < screenHeight) {
      pixel = screenWidth / xCount - 1;
    } else {
      pixel = screenHeight / yCount - 1;
    }

    while (true) {
      pixel += 0.01;
      if (pixel * xCount > screenWidth || pixel * yCount > screenHeight) {
        pixel -= 0.01;
        break;
      }
    }

    Log.d('xCount: $xCount, yCount: $yCount');
    Log.d('pixel: $pixel, screenWidth: $screenWidth, screenHeight: $screenHeight');

    for (var y = 0; y < yCount; y++) {
      for (var x = 0; x < xCount; x++) {
        final cur = y * xCount + x;
        final paint = Paint()
          ..color = colors[cur]
          ..style = PaintingStyle.fill;

        final rect = Rect.fromLTRB(x.toDouble() * pixel, y.toDouble() * pixel, x.toDouble() * pixel + pixel, y.toDouble() * pixel + pixel);
        canvas.drawRect(rect, paint);

        paint.style = PaintingStyle.stroke;
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  // ignore: avoid_renaming_method_parameters
  bool shouldRepaint(PixelPainter oldPainter) {
    return false;
  }
}
