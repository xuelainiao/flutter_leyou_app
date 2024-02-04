import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/utils/location/location.dart';

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
  /// 当前定位控制器
  AampLocation aampLocation = AampLocation(
    options: AMapLocationOption(
      onceLocation: true,
      needAddress: true,
      desiredAccuracy: DesiredAccuracy.HundredMeters,
      desiredLocationAccuracyAuthorizationMode:
          AMapLocationAccuracyAuthorizationMode.ReduceAccuracy,
    ),
  );

  ///用户默认的 经纬度
  late LatLng defaultLatLng;

  /// 定位key
  AMapApiKey amapApiKeys = const AMapApiKey(
    androidKey: AppConfig.amapAndroidKey,
    iosKey: AppConfig.amapIosKey,
  );

  /// 地图 widget
  late AMapWidget map;

  /// 地图 标点icon
  late Uint8List markerIcon;
  final Map<String, Marker> initMarkerMap = <String, Marker>{};

  /// 当前选择的位置
  Map _address = {};
  setAddress(address) {
    _address = address;
    List location = address['location'].split(',');
    LatLng latin1 = LatLng(
      double.parse(location[1]),
      double.parse(location[0]),
    );
    _mapController.moveCamera(CameraUpdate.newLatLng(latin1));
    setState(() {
      initMarkerMap['marker'] = Marker(
        position: latin1,
        draggable: true,
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );
    });
    _address['latitude'] = location[1];
    _address['longitude'] = location[0];
    AampLocation.address = _address;
  }

  /// 回到原始位置
  backPosition() {
    LatLng latLng = AampLocation.address.isEmpty
        ? const LatLng(39.909187, 116.397451)
        : LatLng(double.parse(AampLocation.address['latitude']),
            double.parse(AampLocation.address['longitude']));
    _mapController.moveCamera(CameraUpdate.newLatLng(latLng));
    setState(() {
      initMarkerMap['marker'] = Marker(
        position: latLng,
        draggable: true,
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    rootBundle
        .load('lib/assets/image/aamp_marker_icon.png')
        .then((ByteData byteData) {
      markerIcon = byteData.buffer.asUint8List();
    });
    defaultLatLng = LatLng(
        double.tryParse(AampLocation.address['latitude']) ?? 39.909187,
        double.tryParse(AampLocation.address['longitude']) ?? 116.397451);
  }

  @override
  Widget build(BuildContext context) {
    map = AMapWidget(
      apiKey: amapApiKeys,
      privacyStatement: AMapPrivacyStatement(
        hasContains: true,
        hasShow: true,
        hasAgree: AppConfig.privacyStatementHasAgree,
      ),
      markers: Set<Marker>.of(initMarkerMap.values),
      initialCameraPosition: CameraPosition(
        target: defaultLatLng,
        zoom: 16,
      ),
      onMapCreated: onMapCreated,
      onTap: onLocationTap,
      onPoiTouched: onPoiTouched,
      myLocationStyleOptions: MyLocationStyleOptions(
        true,
      ),
    );

    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 0.5.sh,
                width: 1.sw,
                child: map,
              ),
              Expanded(
                child: AddressPoiList(
                    latLng: defaultLatLng, setAddress: setAddress),
              )
            ],
          ),
          Positioned(
            top: 0.45.sh,
            left: 10.w,
            child: InkWell(
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
                child: const Icon(
                  Icons.my_location_rounded,
                ),
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 14.w,
            right: 14.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  text: '',
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                  ),
                  color: Colors.transparent,
                  borderColor: Colors.transparent,
                  onPressed: () {
                    Get.back(result: null);
                  },
                ),
                Button(
                  text: '确定',
                  radius: 20,
                  onPressed: () {
                    Get.back(result: _address);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  late AMapController _mapController;
  void onMapCreated(AMapController controller) async {
    setState(() {
      _mapController = controller;
      getApprovalNumber();
    });
    aampLocation.getLocation(callback: (address) {
      _address = address;
      _mapController.moveCamera(CameraUpdate.newLatLng(
        LatLng(double.parse(address['latitude']),
            double.parse(address['longitude'])),
      ));
    });
  }

  /// 地图点击回调
  onLocationTap(LatLng latLng) {}

  /// 地图POI点击
  onPoiTouched(AMapPoi poi) {
    if (poi.latLng == null) return;
    setState(() {
      defaultLatLng = poi.latLng!;
      initMarkerMap['marker'] = Marker(
        position: poi.latLng!,
        draggable: true,
        icon: BitmapDescriptor.fromBytes(markerIcon),
      );
    });
  }

  /// 获取审图号
  void getApprovalNumber() async {
    //普通地图审图号
    // String? mapContentApprovalNumber =
    //     await _mapController.getMapContentApprovalNumber();
  }

  @override
  void dispose() {
    aampLocation.closeLocation();
    _mapController.disponse();
    super.dispose();
  }
}
