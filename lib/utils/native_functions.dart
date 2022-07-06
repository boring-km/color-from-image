import 'package:flutter/services.dart';

class NativeFunctions {
  static const methodChannel = MethodChannel('pixel_image');

  static Future<void> shareImage(String filePath, String msg) async {
    await methodChannel.invokeMethod('shareImage', {
      'filePath': filePath,
      'msg': msg,
    });
  }
}
