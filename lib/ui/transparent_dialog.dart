import 'dart:async';

import 'package:flutter/material.dart';

void showTransparentDialog(BuildContext context, Widget child, {FutureOr<dynamic> Function(Object? value)? onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: '',
    barrierDismissible: false,
    barrierColor: Colors.white.withOpacity(0),
    pageBuilder: (context, _, __) {
      return Material(
        type: MaterialType.transparency,
        child: child,
      );
    },
  ).then(onValue ?? (_) => {});
}
