import 'package:permission_handler/permission_handler.dart';

Future<void> _checkPermissions() async {
  var status = await Permission.bluetooth.request();
  if (status.isPermanentlyDenied) {
    print('Bluetooth Permission disabled');
  }
  status = await Permission.bluetoothConnect.request();
  if (status.isPermanentlyDenied) {
    print('Bluetooth Connect Permission disabled');
  }
}

Future<void> requestPermissions() async {
  final micStatus = await Permission.microphone.request();
  final cameraStatus = await Permission.camera.request();

  if (!micStatus.isGranted || !cameraStatus.isGranted) {
    throw Exception("Microphone and camera permissions are required.");
  }
}
