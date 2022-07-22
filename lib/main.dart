import 'package:color_picker/di/binding_setup.dart';
import 'package:color_picker/presentation/camera/camera_view.dart';
import 'package:color_picker/presentation/pixel/pixel_view.dart';
import 'package:color_picker/presentation/qr/qr_view.dart';
import 'package:color_picker/presentation/select/select_view.dart';
import 'package:color_picker/utils/wait_screen_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await waitScreenSizeAvailable();
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
      theme: _buildTheme(context),
      getPages: [
        GetPage(name: '/select', page: () => const SelectView(), binding: SelectViewBindings()),
        GetPage(name: '/pixel', page: () => const PixelView(), binding: PixelViewBindings()),
        GetPage(
          name: '/camera',
          page: () => const CameraView(),
          binding: CameraViewBindings(),
        ),
        GetPage(name: '/qrcode', page: () => const QrView()),
      ],
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final baseTheme = ThemeData(brightness: Brightness.light);
    return baseTheme.copyWith(
      textTheme: GoogleFonts.robotoMonoTextTheme(baseTheme.textTheme),
    );
  }
}
