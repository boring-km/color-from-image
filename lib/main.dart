import 'package:color_picker/di/binding_setup.dart';
import 'package:color_picker/presentation/picker/picker_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'presentation/select/select_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Color Picker',
      debugShowCheckedModeBanner: false,
      initialRoute: '/select',
      getPages: [
        GetPage(name: '/select', page: () => const SelectView(), binding: SelectViewBindings()),
        GetPage(name: '/picker', page: () => const PickerView(), binding: PickerViewBindings()),
      ],
    );
  }
}
