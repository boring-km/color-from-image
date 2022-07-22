import 'package:camera/camera.dart';
import 'package:color_picker/presentation/camera/camera_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraView extends GetView<CameraViewModel> {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GetBuilder<CameraViewModel>(
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: controller.isReady() ? CameraPreview(controller.cameraController!) : null,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: controller.takePicture,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.red),
                    ),
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
