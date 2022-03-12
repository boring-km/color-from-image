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
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              SizedBox(
                height: context.height / 3,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.file(
                    File(controller.originalImageFile.value),
                    height: context.width * (3 / 4),
                    errorBuilder: (context, _, trace) {
                      return const Icon(CupertinoIcons.clear_thick);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: context.height * (2 / 3),
                  child: GridView.builder(
                    itemCount: controller.colors.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.pixelWidthCount,
                      childAspectRatio: 1,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                          color: controller.colors[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
