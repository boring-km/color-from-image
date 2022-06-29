import 'package:color_picker/presentation/pixel/pixel_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PixelView extends GetView<PixelViewModel> {
  const PixelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PixelViewModel>(
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
              title: const Text('Show Pixels'),
            ),
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      panEnabled: true, // Set it to false
                      minScale: 1,
                      maxScale: 4,
                      child: Image.memory(
                        controller.imageBytes,
                        errorBuilder: (context, _, __) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              controller.getSizeText,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
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
                                  child: Text(
                                    controller.hasBeforeString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: controller.savePicture,
                                  style: ElevatedButton.styleFrom(primary: Colors.white),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: controller.sharePicture,
                                  style: ElevatedButton.styleFrom(primary: Colors.white),
                                  child: const Text(
                                    'Share',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: controller.showNext,
                                  style: ElevatedButton.styleFrom(primary: Colors.white),
                                  child: Text(
                                    controller.hasNextString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
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
