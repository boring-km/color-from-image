import 'package:color_picker/presentation/picker/image_painter.dart';
import 'package:color_picker/presentation/picker/picker_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickerView extends GetView<PickerViewModel> {
  const PickerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GetBuilder<PickerViewModel>(
                      builder: (controller) {
                        return ImagePainter(
                          colors: controller.colors,
                          xCount: controller.pixelWidthCount,
                          yCount: controller.pixelHeightCount,
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(controller.imageSizeString),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 24,
                              child: TextField(
                                controller: controller.pixelInputController,
                                keyboardType: TextInputType.number,
                                onSubmitted: controller.setPixelCount(),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => controller.showPixelImages(),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                            ),
                            child: const Text('픽셀 입력'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
