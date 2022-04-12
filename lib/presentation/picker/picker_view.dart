import 'package:color_picker/presentation/picker/image_painter.dart';
import 'package:color_picker/presentation/picker/picker_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickerView extends GetView<PickerViewModel> {
  const PickerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PickerViewModel>(
      builder: (controller) {
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
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      key: controller.saveKey,
                      child: ImagePainter(
                        colors: controller.colors,
                        xCount: controller.pixelWidth,
                        yCount: controller.pixelHeight,
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
                              height: 64,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: controller.showBefore,
                                    child: Text(controller.hasBefore() ? '이전' : '시작'),
                                  ),
                                  ElevatedButton(
                                    onPressed: controller.savePicture,
                                    child: Text('저장'),
                                  ),
                                  ElevatedButton(
                                    onPressed: controller.showNext,
                                    child: Text(controller.hasNext() ? '다음' : '끝'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
