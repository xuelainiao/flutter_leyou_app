import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate;
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/components/not_data/not_data.dart';
import 'package:mall_community/utils/toast/toast.dart';

/// 当前经纬度周边信息
class PoiList extends StatefulWidget {
  const PoiList({
    super.key,
    required this.coordinate,
    required this.setAddress,
    this.controller,
    this.locationPoi,
    this.pois = const [],
  });

  /// 当前默认 poi 列表
  final List<BMFPoiInfo> pois;

  /// 当前定位信息 poi 信息
  final BMFPoiInfo? locationPoi;

  /// 当前经纬度
  final BMFCoordinate coordinate;

  /// 地址选择
  final Function(BMFPoiInfo) setAddress;

  ///滚动控制器
  final ScrollController? controller;

  @override
  State<PoiList> createState() => _PoiListState();
}

class _PoiListState extends State<PoiList> {
  TextStyle textStyle = const TextStyle(
    color: Color.fromRGBO(170, 170, 170, 1),
    fontSize: 14,
  );

  String keyWord = '北京市';
  int total = 0;
  // 搜索获得的poi
  List<BMFPoiInfo> list = [];
  // 逆地理编码获取的poi
  List<BMFPoiInfo> reverseList = [];
  bool loading = false;
  int pageIndex = 0;
  getPoList() async {
    BMFPoiNearbySearch nearbySearch = BMFPoiNearbySearch();
    nearbySearch.onGetPoiNearbySearchResult(callback: (
      BMFPoiSearchResult result,
      BMFSearchErrorCode errorCode,
    ) {
      if (errorCode == BMFSearchErrorCode.NO_ERROR) {
        total = result.totalPOINum ?? 0;
        list.addAll(result.poiInfoList!);
      }
      if (errorCode == BMFSearchErrorCode.RESULT_NOT_FOUND) {
        ToastUtils.showToast("无搜索位置");
      }
      setState(() {
        loading = false;
      });
    });
    setState(() {
      loading = true;
    });
    await nearbySearch.poiNearbySearch(BMFPoiNearbySearchOption(
      keywords: <String>[keyWord],
      location: widget.coordinate,
      radius: 1000,
      pageIndex: pageIndex,
      pageSize: 15,
      isRadiusLimit: true,
    ));
  }

  // 逆地理编码
  reverseGeo() async {
    setState(() {
      loading = true;
    });
    BMFReverseGeoCodeSearch reverseGeoCodeSearch = BMFReverseGeoCodeSearch();
    reverseGeoCodeSearch.onGetReverseGeoCodeSearchResult(callback:
        (BMFReverseGeoCodeSearchResult result, BMFSearchErrorCode errorCode) {
      if (errorCode == BMFSearchErrorCode.NO_ERROR) {
        reverseList = result.poiList ?? [];
        if (widget.locationPoi != null) {
          reverseList.insert(0, widget.locationPoi!);
        }
        total = result.poiList?.length ?? 0;
        loading = false;
        setState(() {});
      }
    });
    await reverseGeoCodeSearch.reverseGeoCodeSearch(
      BMFReverseGeoCodeSearchOption(location: widget.coordinate),
    );
  }

  // 地址搜索
  addressSearch(String tx) {
    keyWord = tx.trim();
    if (keyWord.isEmpty) return;
    rest();
    if (keyWord.isNotEmpty) {
      getPoList();
    }
  }

  // 地址选择
  BMFPoiInfo selectData = BMFPoiInfo();
  addressClick(item) {
    setState(() {
      selectData = item;
    });
    widget.setAddress(item);
  }

  rest() {
    setState(() {
      pageIndex = 0;
      list = [];
    });
  }

  getList() {
    if (list.isNotEmpty) return list;
    return reverseList;
  }

  @override
  void initState() {
    super.initState();
    reverseGeo();
  }

  @override
  void didUpdateWidget(covariant PoiList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinate.latitude != widget.coordinate.latitude) {
      rest();
      reverseGeo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 8,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: HexThemColor(backgroundColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        input(),
        Expanded(child: addressList())
      ],
    );
  }

  Widget input() {
    return Container(
      height: 36.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: HexThemColor(backgroundColor),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        style: textStyle.copyWith(color: Colors.black),
        textInputAction: TextInputAction.send,
        textAlignVertical: TextAlignVertical.center, // 垂直居中对齐
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: '搜索地点位置',
          hintStyle: textStyle,
          border: InputBorder.none,
          counterText: '',
        ),
        onSubmitted: addressSearch,
        onChanged: (value) {
          if (value.trim().isEmpty) {
            rest();
          }
        },
      ),
    );
  }

  Widget addressList() {
    if (loading && list.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 200, child: LoadingText()),
        ],
      );
    }
    if (getList().length > 0) {
      return EasyRefresh(
        onLoad: () async {
          if (getList().length == total) return IndicatorResult.noMore;
          pageIndex += 1;
          await getPoList();
        },
        child: ListView.builder(
          itemCount: getList().length,
          controller: widget.controller,
          padding: EdgeInsets.only(
            bottom: ScreenUtil().bottomBarHeight,
          ),
          itemBuilder: (context, index) => itemBuild(getList()[index], index),
        ),
      );
    } else {
      return SizedBox(
        width: 200.r,
        height: 200.r,
        child: const NotDataIcon(
          status: NetWorkDataStatus.notData,
        ),
      );
    }
  }

  Widget itemBuild(BMFPoiInfo item, i) {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: ListTile(
        selected: selectData.name != null && selectData.name == item.name,
        trailing: selectData.name != null && selectData.name == item.name
            ? const Icon(Icons.done_rounded)
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
        title: Text(
          item.name ?? '',
          style: const TextStyle(overflow: TextOverflow.ellipsis),
          maxLines: 1,
        ),
        subtitle: Text(
          item.address ?? '',
          style: const TextStyle(overflow: TextOverflow.ellipsis),
          maxLines: 1,
        ),
        onTap: () {
          addressClick(item);
        },
      ),
    );
  }
}
