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
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ImagePainter(
                      colors: controller.colors,
                      xCount: controller.pixelWidth,
                      yCount: controller.pixelHeight,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
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
                                  style: ElevatedButton.styleFrom(primary: Colors.white),
                                  child: Text(controller.hasBeforeString(), style: const TextStyle(color: Colors.black),),
                                ),
                                ElevatedButton(
                                  onPressed: controller.savePicture,
                                  style: ElevatedButton.styleFrom(primary: Colors.white),
                                  child: const Text('저장', style: TextStyle(color: Colors.black),),
                                ),
                                ElevatedButton(
                                  onPressed: controller.sharePicture,
                                  style: ElevatedButton.styleFrom(primary: Colors.white),
                                  child: const Text('공유하기', style: TextStyle(color: Colors.black),),
                                ),
                                ElevatedButton(
                                  onPressed: controller.showNext,
                                  style: ElevatedButton.styleFrom(primary: Colors.white),
                                  child: Text(controller.hasNextString(), style: const TextStyle(color: Colors.black),),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
