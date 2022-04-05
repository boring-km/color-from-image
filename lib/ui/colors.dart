import 'package:flutter/material.dart';

Color abgrToColor(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = (argbColor & 0xFF) << 16;
  int g = argbColor & 0xFF00FF00;
  return Color(r | g | b);
}