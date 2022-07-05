import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPhotosPermission() async {
  if (!await Permission.photos.isGranted) {
    final res = await Permission.photos.request();
    return _processGranted(res);
  }
  return true;
}

Future<bool> checkCameraPermission() async {
  if (!await Permission.camera.isGranted) {
    final res = await Permission.camera.request();
    return _processGranted(res);
  }
  return true;
}

Future<bool> checkStoragePermission() async {
  if (!await Permission.storage.isGranted) {
    final res = await Permission.storage.request();
    return _processGranted(res);
  }
  return true;
}

Future<bool> _processGranted(PermissionStatus res) async {
  if (!res.isGranted) {
    if (res.isPermanentlyDenied) {
      try {
        return await openAppSettings();
      } catch (e) {
        return false;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
}
