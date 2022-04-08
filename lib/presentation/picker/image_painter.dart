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

class _ImagePainterState extends State<ImagePainter> {

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

    if (colors.isEmpty) {
      return;
    }

    double screenWidth = Get.context?.size?.width ?? 390.0;
    double screenHeight = Get.context?.size?.height ?? 800.0;
    double size = screenWidth / xCount - 1;

    double ratio = xCount / screenWidth;
    double chunk = ratio > 1 ? 1 / ratio : ratio;

    while (true) {
      size += 0.00001;
      if (size * xCount > screenWidth || size * yCount > screenHeight) {
        size -= 0.00001;
        break;
      }
    }

    Log.d('width: $size, chunk: $chunk, xCount: $xCount, yCount: $yCount, screen width: $screenWidth');

    for (int y = 0; y < yCount; y++) {
      for (int x = 0; x < xCount; x++) {
        var cur = y * xCount + x;
        final paint = Paint()
          ..color = colors[cur]
          ..style = PaintingStyle.fill;

        final rect = Rect.fromLTRB(x.toDouble() * size, y.toDouble() * size,
            x.toDouble() * size + size, y.toDouble() * size + size);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_PixelPainter oldPainter) {
    return false;
  }
}
