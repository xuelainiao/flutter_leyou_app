import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/pages/map_search/poi_list.dart';
import 'package:mall_community/utils/location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isOpen = false;
  // 当前定位介绍或者poi中文名
  late String poiTx;
  BMFPoiInfo? locationPoi;
  double mapHeight = 0.8.sh;
  double minHeight = 0.2.sh;
  double maxHeight = 0.6.sh;
  int zoom = 18;
  late BMFCoordinate coordinate;
  late BMFMapOptions mapOptions;
  late BMFMapController _controller;

  // 地图控制器创建
  onBMFMapCreated(BMFMapController controller) async {
    _controller = controller;
    await _controller.showUserLocation(true);
    _controller.setMapRegionDidChangeWithReasonCallback(callback: moveListent);
    _controller.setMapOnClickedMapPoiCallback(callback: mapPoiClick);
    BdLocation().getLocation(callBack: (res) {
      if (res.longitude != null && res.latitude != null) {
        moveMap(LatLng(res.latitude!, res.longitude!));
        setUserLocation();
        locationPoi = BMFPoiInfo().fromMap(res.getMap());
        if (res.longitude != null) {
          locationPoi?.pt = BMFCoordinate(res.latitude!, res.longitude!);
        }
        locationPoi?.name = res.town ?? '当前位置';
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {});
        });
      }
    });
  }

  // 移动地图中心点
  moveMap(LatLng latLng) async {
    BMFCoordinate coordinate = BMFCoordinate(latLng.latitude, latLng.longitude);
    _controller.setCenterCoordinate(
      coordinate,
      true,
      animateDurationMs: 300,
    );
    // _controller.updateMapOptions(BMFMapOptions(
    //     zoomLevel: zoom,
    //     center: BMFCoordinate(latLng.latitude, latLng.longitude)));
  }

  //地图中心点移动监听
  moveListent(BMFMapStatus status, BMFRegionChangeReason reason) {
    if (reason == BMFRegionChangeReason.Gesture && status.targetGeoPt != null) {
      setState(() {
        coordinate = status.targetGeoPt!;
      });
    }
  }

  // 地图poi点击监听
  mapPoiClick(BMFMapPoi poi) {
    if (poi.pt != null) {
      moveMap(LatLng(poi.pt!.latitude, poi.pt!.longitude));
    }
  }

  //设置当前用户位置
  setUserLocation() {
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);
    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    _controller.updateLocationData(userLocation);
  }

  //当前地址选择
  BMFPoiInfo? address;
  setAddress(BMFPoiInfo ad) {
    setState(() {
      address = ad;
    });
    if (ad.pt?.latitude != null) {
      moveMap(LatLng(ad.pt!.latitude, ad.pt!.longitude));
    }
  }

  @override
  void initState() {
    super.initState();
    if (BdLocation.address != null && BdLocation.address?.latitude != null) {
      coordinate = BMFCoordinate(
          BdLocation.address!.latitude!, BdLocation.address!.longitude!);
    } else {
      coordinate = BMFCoordinate(39.917215, 116.380341);
    }
    mapOptions = BMFMapOptions(
      center: coordinate,
      zoomLevel: zoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SlidingUpPanel(
          body: Stack(
            children: [
              SizedBox(
                height: mapHeight,
                child: BMFMapWidget(
                  onBMFMapCreated: onBMFMapCreated,
                  mapOptions: mapOptions,
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
            ],
          ),
          minHeight: minHeight,
          maxHeight: maxHeight,
          parallaxEnabled: true,
          parallaxOffset: 0.5,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          backdropColor: Colors.white,
          panelBuilder: (sc) {
            return locationPoi != null
                ? PoiList(
                    controller: sc,
                    locationPoi: locationPoi,
                    coordinate: coordinate,
                    setAddress: setAddress,
                  )
                : const Column(
                    children: [SizedBox(height: 80), LoadingText()],
                  );
          },
          onPanelClosed: () {
            moveMap(LatLng(coordinate.latitude, coordinate.longitude));
          },
          onPanelOpened: () {
            moveMap(LatLng(coordinate.latitude, coordinate.longitude));
          },
        ),
        navBar(),
      ]),
    );
  }

  Widget navBar() {
    return Positioned(
      width: 1.sw,
      child: Container(
        height: ScreenUtil().statusBarHeight + 40,
        padding: EdgeInsets.only(
            top: ScreenUtil().statusBarHeight, left: 20, right: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 0.6),
              Color.fromRGBO(0, 0, 0, 0),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Button(
              radius: 8,
              onPressed: () {
                Get.back(result: address);
              },
              text: '发送',
              enable: address == null,
              borderColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LatLng {
  late double latitude;
  late double longitude;
  LatLng(double lat, double long) {
    latitude = lat;
    longitude = long;
  }
}
