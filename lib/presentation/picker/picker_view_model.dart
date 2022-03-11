import 'package:get/get.dart';

class PickerViewModel extends GetxController {

  RxString imagePath = ''.obs;

  @override
  void onInit() {
    imagePath = (Get.arguments['path'] as String).obs;
    super.onInit();
  }

}