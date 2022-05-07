import 'package:color_picker/presentation/select/select_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectView extends GetView<SelectViewModel> {
  const SelectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Show Pixels'),
      ),
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  controller.showImageFromCamera();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width / 3,
                      height: width / 3,
                      child: Image.asset(
                        'images/camera.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Camera',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: () {
                  controller.showImageFromGallery();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width / 3,
                      height: width / 3,
                      child: Center(
                        child: Image.asset(
                          'images/gallery.png',
                          fit: BoxFit.fitWidth,
                          width: width / 4,
                        ),
                      ),
                    ),
                    Text(
                      'Photos',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
