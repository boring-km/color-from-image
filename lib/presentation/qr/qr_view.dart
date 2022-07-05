import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrView extends GetView {
  const QrView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: QrImage(
          data: '1234567890',
          foregroundColor: Colors.lightBlue,
          size: 200,
        ),
      ),
    );
  }
}
