import 'dart:io';

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
                    alignment: Alignment.center,
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
                Text(controller.colorInfo),
                const SizedBox(
                  height: 16,
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      controller.showPixelImages();
                    },
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
          child: GridView.builder(
            itemCount: controller.colors.length,
            shrinkWrap: true,
            primary: true,
            padding: const EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: controller.pixelWidthCount,
              childAspectRatio: 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => controller.getColorInfo(index),
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    color: controller.colors[index],
                    border: controller.isSelectedIndex(index)
                        ? Border.all(color: Colors.red, width: 1)
                        : null,
                  ),
                ),
              );
            },
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
