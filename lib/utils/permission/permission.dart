import 'package:permission_handler/permission_handler.dart';

/// app权限
class AppPermission {
  /// 判断权限并且获取权限
  static Future<bool> getPermission(Permission permission) async {
    //granted 通过，denied 被拒绝，permanentlyDenied 拒绝且不在提示
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    }
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      PermissionStatus st = await requestPermission(permission);
      return st == PermissionStatus.granted;
    }
    return false;
  }

  /// 判断权限是否存在
  static Future<bool> hasPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    return status.isGranted;
  }

  /// 申请权限
  static requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return await permission.status;
    }
    return status;
  }
}
