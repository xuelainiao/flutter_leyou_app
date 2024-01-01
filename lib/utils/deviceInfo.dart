import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// 设备信息
class DeviceInfo {
  static final DeviceInfo _instance = DeviceInfo._internal();
  late DeviceInfoPlugin _deviceInfo;
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;

  factory DeviceInfo() {
    return _instance;
  }

  DeviceInfo._internal() {
    initDeviceInfo();
  }

  initDeviceInfo() async {
    _deviceInfo = DeviceInfoPlugin();
  }

  Future getInfo() async {
    if (Platform.isAndroid) {
      androidInfo ??= await _deviceInfo.androidInfo;
      return androidInfo!;
    } else if (Platform.isIOS) {
      iosInfo ??= await _deviceInfo.iosInfo;
      return iosInfo;
    }
  }
}
