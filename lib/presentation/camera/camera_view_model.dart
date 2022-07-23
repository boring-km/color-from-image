import 'dart:async';

import 'package:camera/camera.dart';
import 'package:color_picker/core/logger.dart';
import 'package:get/get.dart';

class CameraViewModel extends GetxController {
  CameraController? cameraController;

  @override
  void onInit() {
    Future.microtask(() async {
      final cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      await cameraController?.initialize().then((_) {
        update();
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              Log.e('User denied camera access.');
              break;
            default:
              Log.e('Handle other errors.');
              break;
          }
        }
      });
    });
    super.onInit();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  bool isReady() {
    return cameraController?.value.isInitialized ?? false;
  }

  Future<void> takePicture() async {
    final filePath = (await cameraController?.takePicture())?.path ?? '';
    unawaited(Get.offAndToNamed(
      '/pixel',
      arguments: {
        'path': filePath,
      },
    ));
  }
}
