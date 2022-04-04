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
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 4),
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
                              height: 64,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.pixelWidthList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.showPixelImages(controller.pixelWidthList[index]);
                                      },
                                      child: Text((controller.pixelWidthList[index] - 1).toString()),
                                    ),
                                  );
                                },
                              ),
                            ),
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
