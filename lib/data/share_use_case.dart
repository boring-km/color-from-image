import 'dart:io';
import 'dart:typed_data';

import 'package:color_picker/core/logger.dart';
import 'package:color_picker/core/permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareUseCase {
  static share(ByteData pngBytes) async {
    final savePath = (await _getShareFilePath(pngBytes)).replaceAll('file://', '');
    if (await File(savePath).exists()) {
      Log.i('is exists');
      await Share.shareFiles([savePath], subject: 'Share Your Pixel Image');
      await File(savePath).delete();
    } else {
      Log.e('is not exists');
    }
  }

  static Future<String> _getShareFilePath(ByteData pngBytes) async {
    final hasPermission = await checkStoragePermission();
    Log.i('hasPermission: $hasPermission');
    if (hasPermission) {
      final Uint8List bytes = Uint8List.fromList(pngBytes.buffer.asUint8List());
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
