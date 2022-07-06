// ignore_for_file: avoid_slow_async_io

import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/core/logger.dart';
import 'package:color_picker/core/permissions.dart';
import 'package:color_picker/utils/native_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareUseCase {
  static Future<void> share(ByteData pngBytes) async {
    final savePath = (await _getShareFilePath(pngBytes)).replaceAll('file://', '');
    if (await File(savePath).exists()) {
      Log.i('Temp Image is exists');
      if (Platform.isAndroid) {
        await Share.shareFiles([savePath], mimeTypes: ['image/png'], text: 'Share Your Pixel Image', subject: 'Pixel Image');
      } else {
        await NativeFunctions.shareImage(savePath, 'Share Your Pixel Image');
      }
    } else {
      Log.e('Temp Image is not exists');
    }
  }

  static Future<String> _getShareFilePath(ByteData pngBytes) async {
    final hasPermission = await checkStoragePermission();
    Log.i('hasPermission: $hasPermission');
    if (hasPermission) {
      final bytes = Uint8List.fromList(pngBytes.buffer.asUint8List());
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/pixel_temp.jpg';
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
}
