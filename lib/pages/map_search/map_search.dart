import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/utils/location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'address_poi_list.dart';

class ShowMapPage extends StatelessWidget {
  const ShowMapPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _ShowMapPageBody();
  }
}

class _ShowMapPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<_ShowMapPageBody> {
  late AMapController _mapController;
  bool isTouchMove = true;
  double mapHeight = 0.8.sh;
  double minHeight = 0.2.sh;
  double maxHeight = 0.6.sh;
  double zoom = 16;

  //当前选择经纬度
  LatLng? defaultLatLng;

  // 定位key
  AMapApiKey amapApiKeys = const AMapApiKey(
    androidKey: AppConfig.amapAndroidKey,
    iosKey: AppConfig.amapIosKey,
  );

  // 当前选择的位置
  Map _address = {};
  setAddress(address) {
    _address = address;
    isTouchMove = false;
    List location = address['location'].split(',');
    LatLng latin1 = LatLng(
      double.parse(location[1]),
      double.parse(location[0]),
    );
    defaultLatLng = latin1;
    moveMap(latin1);
    _address['latitude'] = location[1];
    _address['longitude'] = location[0];
    // AampLocation.address = _address;
  }

  // 回到原始位置
  backPosition() {
    LatLng latLng = LatLng(
      AampLocation.address?.latitude ?? 39.909187,
      AampLocation.address?.longitude ?? 116.397451,
    );
    moveMap(latLng);
  }

  // 地图创建回调
  void onMapCreated(AMapController controller) async {
    setState(() {
      _mapController = controller;
      getApprovalNumber();
    });
    AampLocation().getLocation(callback: (res) {
      moveMap(LatLng(res.latitude!, res.longitude!));
    });
  }

  // 地图点击回调
  onLocationTap(LatLng latLng) {}

  // 地图POI点击
  onPoiTouched(AMapPoi poi) {
    if (poi.latLng == null) return;
    moveMap(poi.latLng!);
    setState(() {
      defaultLatLng = poi.latLng!;
    });
  }

  // 地图移动结束
  onCameraMoveEnd(CameraPosition position) {
    if (isTouchMove) {
      setState(() {
        isTouchMove = true;
        defaultLatLng = position.target;
      });
    }
  }

  // 获取审图号
  void getApprovalNumber() async {
    //普通地图审图号
    // String? mapContentApprovalNumber =
    //     await _mapController.getMapContentApprovalNumber();
  }

  // 地图移动根据经纬度
  moveMap(LatLng latLng) {
    _mapController.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: zoom, tilt: 30),
    ));
  }

  @override
  void initState() {
    super.initState();
    defaultLatLng = LatLng(
      AampLocation.address?.latitude ?? 39.909187,
      AampLocation.address?.longitude ?? 116.397451,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SlidingUpPanel(
        body: Stack(
          children: [
            mapView(),
            Positioned(
              right: 8,
              top: 100,
              child: Container(
                height: 40.h,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    InkWell(
                      onTap: backPosition,
                      child: Container(
                        width: 34.r,
                        height: 34.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.my_location_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: mapHeight / 2 - 40,
              width: 40,
              left: 1.sw / 2 - 20,
              child: Image.asset(
                'lib/assets/image/aamp_marker_icon.png',
              ),
            ),
            Positioned(
              top: ScreenUtil().statusBarHeight,
              left: 14.w,
              right: 14.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Get.back(result: null);
                    },
                  ),
                  Button(
                    text: '确定',
                    radius: 40,
                    onPressed: () {
                      Get.back(result: _address);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        panel: AddressPoiList(setAddress: setAddress, latLng: defaultLatLng,),
        boxShadow: null,
        color: Colors.transparent,
        backdropColor: Colors.transparent,
        minHeight: minHeight,
        maxHeight: maxHeight,
        onPanelOpened: () async {
          moveMap(defaultLatLng!);
        },
        onPanelClosed: () async {
          moveMap(defaultLatLng!);
        },
        onPanelSlide: (position) {
          double diffHeight = 0.6.sh * position;
          setState(() {
            mapHeight =
                1.sh - (diffHeight <= minHeight ? minHeight : diffHeight);
          });
        },
      ),
    );
  }

  Widget mapView() {
    return SizedBox(
      height: mapHeight,
      child: AMapWidget(
        apiKey: amapApiKeys,
        privacyStatement: AMapPrivacyStatement(
          hasContains: AppConfig.privacyStatementHasAgree,
          hasShow: AppConfig.privacyStatementHasAgree,
          hasAgree: AppConfig.privacyStatementHasAgree,
        ),
        initialCameraPosition: CameraPosition(
          target: defaultLatLng!,
          zoom: zoom,
          tilt: 30,
        ),
        onMapCreated: onMapCreated,
        onTap: onLocationTap,
        onPoiTouched: onPoiTouched,
        onCameraMoveEnd: onCameraMoveEnd,
        myLocationStyleOptions: MyLocationStyleOptions(
          true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.disponse();
    super.dispose();
  }
}
