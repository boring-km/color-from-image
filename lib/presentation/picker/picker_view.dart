import 'dart:io';

import 'package:color_picker/presentation/picker/image_painter.dart';
import 'package:color_picker/presentation/picker/picker_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickerView extends GetView<PickerViewModel> {
  const PickerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 40,
            height: 40,
            color: Colors.transparent,
            child: const Icon(CupertinoIcons.back),
          ),
        ),
        title: const Text('Color Extractor'),
      ),
      body: SafeArea(
        child: Center(
          child: GetBuilder<PickerViewModel>(builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: context.height * (2 / 3),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GetBuilder<PickerViewModel>(
                      builder: (controller) {
                        return showSelectedImage(controller);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20, height: 20,
                      color: controller.selectedColor,
                    ),
                    const SizedBox(width: 10,),
                    Text(controller.colorInfo),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.showPixelImages,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    child: Text(controller.showButtonText.value),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget showSelectedImage(PickerViewModel controller) {
    if (controller.isPixelShow) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: controller.isOriginalImageVisible ? 0.0 : 1.0,
        child: SizedBox(
          width: Get.context!.width * (3 / 4),
          child: ImagePainter(
            colors: controller.colors,
            xCount: controller.pixelWidthCount,
            yCount: controller.pixelHeightCount,
          ),
        ),
      );
    } else {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: controller.isOriginalImageVisible ? 1.0 : 0.0,
        child: Image.file(
          File(controller.originalImageFile.value),
          fit: BoxFit.cover,
          errorBuilder: (context, _, trace) {
            return const Icon(CupertinoIcons.clear_thick);
          },
        ),
      );
    }
  }
}
