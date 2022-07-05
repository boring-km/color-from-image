import 'dart:typed_data';

import 'package:color_picker/core/permissions.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class SaveUseCase {
  static Future<String> save(ByteData pngBytes) async {
    final hasPermission = await checkStoragePermission();
    if (hasPermission) {
      await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes.buffer.asUint8List()),
        quality: 100,
        name: 'pixel_image',
        isReturnImagePathOfIOS: true,
      );
      return 'Image Saved!';
    } else {
      return 'Permission Denied';
    }
  }
}
