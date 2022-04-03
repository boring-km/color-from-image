import 'package:color_picker/core/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePainter extends StatefulWidget {
  final List<Color> colors;
  final int xCount;
  final int yCount;

  const ImagePainter({
    Key? key,
    required this.colors,
    required this.xCount,
    required this.yCount,
  }) : super(key: key);

  @override
  State<ImagePainter> createState() => _ImagePainterState();
}

class _ImagePainterState extends State<ImagePainter> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PixelPainter(
        colors: widget.colors,
        xCount: widget.xCount,
        yCount: widget.yCount,
      ),
    );
  }
}

class _PixelPainter extends CustomPainter {
  final List<Color> colors;
  final int xCount;
  final int yCount;

  _PixelPainter({
    required this.colors,
    required this.xCount,
    required this.yCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double width = 0;
    double screenWidth = Get.context?.size?.width ?? 390.0;
    double screenHeight = Get.context?.size?.height ?? 800.0;

    double ratio = xCount / screenWidth;
    double chunk = ratio > 1 ? 1 / ratio : ratio;
    Log.d('증가 단위: $chunk');

    while (true) {
      width += 0.00001;
      if (width * xCount > screenWidth || width * yCount > screenHeight) {
        width -= 0.00001;
        break;
      }
    }

    Log.d('width: $width, chunk: $chunk, ratio: $ratio, xCount: $xCount, yCount: $yCount, screen width: $screenWidth');



    for (int y = 0; y < yCount; y++) {
      for (int x = 0; x < xCount; x++) {
        final paint = Paint()
          ..color = colors[y * xCount + x]
          ..style = PaintingStyle.fill;

        final size = width / 2;
        final rect = Rect.fromLTRB(x.toDouble() * width - size, y.toDouble() * width - size,
            x.toDouble() * width + size, y.toDouble() * width + size);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PixelPainter oldPainter) {
    return oldPainter.xCount != xCount || oldPainter.yCount != yCount;
  }
}
