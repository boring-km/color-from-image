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
      painter: PixelPainter(
        colors: widget.colors,
        xCount: widget.xCount,
        yCount: widget.yCount,
      ),
    );
  }
}

class PixelPainter extends CustomPainter {
  final List<Color> colors;
  final int xCount;
  final int yCount;
  double pixel = 0;

  PixelPainter({
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
    pixel = screenWidth / xCount - 1;

    while (true) {
      pixel += 0.00001;
      if (pixel * xCount > screenWidth || pixel * yCount > screenHeight) {
        pixel -= 0.00001;
        break;
      }
    }

    for (int y = 0; y < yCount; y++) {
      for (int x = 0; x < xCount; x++) {
        var cur = y * xCount + x;
        final paint = Paint()
          ..color = colors[cur]
          ..style = PaintingStyle.fill;

        final rect = Rect.fromLTRB(x.toDouble() * pixel, y.toDouble() * pixel,
            x.toDouble() * pixel + pixel, y.toDouble() * pixel + pixel);
        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(PixelPainter oldPainter) {
    return false;
  }
}
