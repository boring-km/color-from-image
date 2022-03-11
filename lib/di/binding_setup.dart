import 'package:get/get.dart';

import '/presentation/select/select_view_model.dart';
import '/presentation/picker/picker_view_model.dart';

class SelectViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SelectViewModel());
  }
}

class PickerViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(PickerViewModel());
  }

}