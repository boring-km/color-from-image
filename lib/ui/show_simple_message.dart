import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSimpleMessage(String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}
