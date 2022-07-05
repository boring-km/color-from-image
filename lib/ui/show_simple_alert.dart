import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSimpleAlert(String msg) {
  // ignore: inference_failure_on_function_invocation
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Text(msg, textAlign: TextAlign.center,),
        actions: [
          Center(
            child: CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay'),
            ),
          ),
        ],
      );
    },
  );
}
