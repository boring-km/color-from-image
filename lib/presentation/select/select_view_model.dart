import 'package:color_picker/core/permissions.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelectViewModel extends GetxController {
  final _imagePicker = Get.put(ImagePicker());

  showImageFromCamera() async {
    if (await checkCameraPermission()) {
      String imagePath = await _getImagePath(ImageSource.camera);
      moveToPickerView(imagePath);
    }
  }

  showImageFromGallery() async {
    if (await checkPhotosPermission()) {
      String imagePath = await _getImagePath(ImageSource.gallery);
      moveToPickerView(imagePath);
    }
  }

  void moveToPickerView(String imagePath) {
    if (imagePath.isEmpty) return;
    Get.toNamed('/pixel', arguments: {
      'path': imagePath,
    });
  }

  Future<String> _getImagePath(ImageSource imageSource) async {
    final XFile? image = await _imagePicker.pickImage(source: imageSource);
    final String imagePath = image?.path ?? '';
    return imagePath;
  }
}
