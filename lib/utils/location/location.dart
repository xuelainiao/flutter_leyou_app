import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:mall_community/utils/permission/permission.dart';
import 'package:mall_community/utils/storage.dart';
import 'package:mall_community/utils/toast/toast.dart';
import 'package:permission_handler/permission_handler.dart';

class AampLocation {
  static AampLocation? _instance;

  /// 定位控制器
  late AMapFlutterLocation amapLocation;

  /// 当前定位参数
  late AMapLocationOption option;

  /// 当前定位消息
  /// {locTime: 2023-09-14 16:24:46, province: 广东省, callbackTime: 2023-09-14 16:24:50, district: 白云区, country: 中国, street: 航云南街, speed: -1.0, latitude: 23.173277, city: 广州市, streetNumber: 102号, bearing: -1.0, accuracy: 35.0, adCode: 440111, altitude: 22.018461227416992, locationType: 1, longitude: 113.261964, cityCode: 020, address: 广东省广州市白云区航云南街靠近集盛大厦, description: 广东省广州市白云区航云南街靠近集盛大厦}
  static Map address = {};

  factory AampLocation({required AMapLocationOption options}) {
    _instance ??= AampLocation._internal(options);
    return _instance!;
  }

  AampLocation._internal(AMapLocationOption op) {
    option = op;
    amapLocation = AMapFlutterLocation();
    amapLocation.setLocationOption(option);
    address = Storage().read('address') ?? {};
  }

  /// 获取当前定位
  /// AMapLocationOption options 当前定位参数
  /// callback 持续定位回调
  getLocation({Function(Map)? callback}) async {
    var result = await AppPermission.getPermission(Permission.location);
    if (result) {
      amapLocation.startLocation();
      amapLocation.onLocationChanged().listen((event) {
        if (event.containsKey("errorCode")) {
          ToastUtils.showToast(event['errorInfo'].toString());
          return;
        }
        address = event;
        callback?.call(event);
        if (option.onceLocation) {
          Storage().write('address', event);
        }
      }, onError: (e) {
        ToastUtils.showToast('定位失败');
      });
    }
  }

  /// 结束定位
  closeLocation() {
    amapLocation.stopLocation();
    amapLocation.destroy();
  }
}
