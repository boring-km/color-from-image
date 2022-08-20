import 'package:color_picker/di/binding_setup.dart';
import 'package:color_picker/presentation/camera/camera_view.dart';
import 'package:color_picker/presentation/pixel/pixel_view.dart';
import 'package:color_picker/presentation/select/select_view.dart';
import 'package:get/get.dart';

class Routes {
  static const select = '/select';
  static const pixel = '/pixel';
  static const camera = '/camera';
}

class Pages {
  static final pages = [
    GetPage(
      name: Routes.select,
      page: () => const SelectView(),
      binding: SelectViewBindings(),
    ),
    GetPage(
      name: Routes.pixel,
      page: () => const PixelView(),
      binding: PixelViewBindings(),
    ),
    GetPage(
      name: Routes.camera,
      page: () => const CameraView(),
      binding: CameraViewBindings(),
    ),
  ];
}
