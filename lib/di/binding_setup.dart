import 'package:color_picker/presentation/camera/camera_view_model.dart';
import 'package:color_picker/presentation/pixel/pixel_view_model.dart';
import 'package:color_picker/presentation/select/select_view_model.dart';
import 'package:get/get.dart';

class SelectViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SelectViewModel());
  }
}

class PixelViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PixelViewModel());
  }
}

class CameraViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(CameraViewModel());
  }
}
