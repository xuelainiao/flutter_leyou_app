import 'dart:io';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/utils/permission/permission.dart';
import 'package:mall_community/utils/storage.dart';
import 'package:permission_handler/permission_handler.dart';

/// 百度定位
class BdLocation {
  static BdLocation? _instance;

  /// 定位控制器
  static LocationFlutterPlugin? _bdLocPlugin;

  /// 定位数据
  static BaiduLocation? address;

  BdLocation._internal() {
    _bdLocPlugin ??= LocationFlutterPlugin();
    // Map? event = Storage().read('address');
    // address = event == null ? null : BaiduLocation.fromMap(event);
  }

  factory BdLocation() {
    _instance ??= BdLocation._internal();
    return _instance!;
  }

  /// 初始化
  Future<void> init() async {
    // 否隐私政策
    _bdLocPlugin?.setAgreePrivacy(AppConfig.privacyStatementHasAgree);
    BMFMapSDK.setAgreePrivacy(AppConfig.privacyStatementHasAgree);
    if (Platform.isIOS) {
      _bdLocPlugin?.authAK(AppConfig.amapIosKey);
      BMFMapSDK.setApiKeyAndCoordType(
        AppConfig.amapIosKey,
        BMF_COORD_TYPE.BD09LL,
      );
    } else if (Platform.isAndroid) {
      BMFAndroidVersion.initAndroidVersion();
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }

    debugPrint("地图定位初始化完毕${AppConfig.privacyStatementHasAgree}");
  }

  /// 获取当前位置 单次
  Future getLocation({
    required Function(BaiduLocation) callBack,
  }) async {
    await AppPermission.getPermission(Permission.location);
    Map iosMap = _initIOSOptions().getMap();
    Map androidMap = _initAndroidOptions().getMap();
    await _bdLocPlugin?.prepareLoc(androidMap, iosMap);

    if (Platform.isIOS) {
      _bdLocPlugin?.singleLocationCallback(callback: (BaiduLocation result) {
        address = result;
        callBack(result);
        Storage().write('address', result.getMap());
      });
      await _bdLocPlugin
          ?.singleLocation({'isReGeocode': true, 'isNetworkState': true});
    } else if (Platform.isAndroid) {
      _bdLocPlugin?.seriesLocationCallback(callback: (BaiduLocation result) {
        address = result;
        callBack(result);
        _bdLocPlugin?.stopLocation();
        Storage().write('address', result.getMap());
      });
      await _bdLocPlugin?.startLocation();
    }
  }

  ///连续定位
  Future seriesLocation({
    required Function(BaiduLocation) callBack,
  }) async {
    await AppPermission.getPermission(Permission.locationAlways);
    Map iosMap = _initIOSOptions().getMap();
    Map androidMap = _initAndroidOptions(scanspan: 4000).getMap();
    await _bdLocPlugin?.prepareLoc(androidMap, iosMap);

    _bdLocPlugin?.seriesLocationCallback(callback: (BaiduLocation result) {
      callBack(result);
    });
    await _bdLocPlugin?.startLocation();
  }

  ///连续定位关闭
  Future stopLocation() async {
    await _bdLocPlugin?.stopLocation();
  }

  BaiduLocationAndroidOption _initAndroidOptions({int scanspan = 0}) {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
        // 定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
        locationMode: BMFLocationMode.hightAccuracy,
        // 是否需要返回地址信息
        isNeedAddress: true,
        // 是否需要返回海拔高度信息
        isNeedAltitude: true,
        // 是否需要返回周边poi信息
        isNeedLocationPoiList: true,
        // 是否需要返回新版本rgc信息
        isNeedNewVersionRgc: true,
        // 是否需要返回位置描述信息
        isNeedLocationDescribe: true,
        // 是否使用gps
        openGps: true,
        // 可选，设置场景定位参数，包括签到场景、运动场景、出行场景
        locationPurpose: BMFLocationPurpose.signIn,
        // 坐标系
        coordType: BMFLocationCoordType.bd09ll,
        // 设置发起定位请求的间隔，int类型，单位ms
        // 如果设置为0，则代表单次定位，即仅定位一次，默认为0
        scanspan: scanspan);
    return options;
  }

  BaiduLocationIOSOption _initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
      // 坐标系
      coordType: BMFLocationCoordType.bd09ll,
      // 位置获取超时时间
      locationTimeout: 10,
      // 获取地址信息超时时间
      reGeocodeTimeout: 10,
      // 应用位置类型 默认为automotiveNavigation
      activityType: BMFActivityType.automotiveNavigation,
      // 设置预期精度参数 默认为best
      desiredAccuracy: BMFDesiredAccuracy.best,
      // 是否需要最新版本rgc数据
      isNeedNewVersionRgc: true,
      // 指定定位是否会被系统自动暂停
      pausesLocationUpdatesAutomatically: false,
      // 指定是否允许后台定位,
      // 允许的话是可以进行后台定位的，但需要项目
      // 配置允许后台定位，否则会报错，具体参考开发文档
      allowsBackgroundLocationUpdates: true,
      // 设定定位的最小更新距离
      distanceFilter: 10,
    );
    return options;
  }
}
