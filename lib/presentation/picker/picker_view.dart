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
          child: Obx(
            () => Image.file(
              File(controller.imagePath.value),
              errorBuilder: (context, object, trace) {
                return const Icon(CupertinoIcons.clear);
              },
            ),
          ),
        ),
      ),
    );
  }
}
