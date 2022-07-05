import 'package:flutter/material.dart';

Color abgrToColor(int argbColor) {
  final r = (argbColor >> 16) & 0xFF;
  final b = (argbColor & 0xFF) << 16;
  final g = argbColor & 0xFF00FF00;
  return Color(r | g | b);
}
