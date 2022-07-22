import 'dart:async';

import 'package:color_picker/core/permissions.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelectViewModel extends GetxController {
  final _imagePicker = Get.put(ImagePicker());

  Future<void> showImageFromCamera() async {
    if (await checkCameraPermission()) {
      unawaited(Get.toNamed('/camera'));
    }
  }

  Future<void> showImageFromGallery() async {
    if (await checkPhotosPermission()) {
      final imagePath = await _getImagePath(ImageSource.gallery);
      moveToPickerView(imagePath);
    }
  }

  void moveToPickerView(String imagePath) {
    if (imagePath.isEmpty) return;
    // ignore: inference_failure_on_function_invocation
    Get.toNamed(
      '/pixel',
      arguments: {
        'path': imagePath,
      },
    );
  }

  Future<String> _getImagePath(ImageSource imageSource) async {
    final image = await _imagePicker.pickImage(source: imageSource);
    final imagePath = image?.path ?? '';
    return imagePath;
  }
}
