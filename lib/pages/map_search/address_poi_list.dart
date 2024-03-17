// import 'package:amap_flutter_base/amap_flutter_base.dart';
// import 'package:dio/dio.dart';
// import 'package:easy_refresh/easy_refresh.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mall_community/common/app_config.dart';
// import 'package:mall_community/common/comm_style.dart';
// import 'package:mall_community/components/loading/loading.dart';
// import 'package:mall_community/components/not_data/not_data.dart';
// import 'package:mall_community/utils/toast/toast.dart';

// class AddressPoiList extends StatefulWidget {
//   const AddressPoiList({
//     super.key,
//     this.latLng,
//     required this.setAddress,
//   });

//   final LatLng? latLng;

//   final Function(Map) setAddress;

//   @override
//   State<AddressPoiList> createState() => _AddressPoiListState();
// }

// class _AddressPoiListState extends State<AddressPoiList> {
//   TextStyle textStyle = const TextStyle(
//     color: Color.fromRGBO(170, 170, 170, 1),
//     fontSize: 14,
//   );

//   List list = [];
//   Dio dio = Dio();
//   bool loading = false;
//   Map<String, dynamic> query = {
//     'keywords': '', //多个关键字用“|”分割
//     'types': '120000', //查询POI类型 多个类型用“|”分割
//     'page': 1,
//     'key': AppConfig.amapWebkey,
//   };
//   getList() {
//     if (widget.latLng == null) return;
//     query['location'] =
//         "${widget.latLng!.latitude},${widget.latLng!.longitude}";
//     setState(() {
//       loading = true;
//     });
//     dio
//         .get("https://restapi.amap.com/v3/place/around",
//             queryParameters: query, options: Options())
//         .then((res) {
//       if (res.data['status'] != '1') {
//         if (res.data['infocode'] == '10044') {
//           ToastUtils.showToast('接口调用超出限制');
//         }
//         return;
//       }
//       setState(() {
//         list.addAll(res.data['suggestion']['keywords']);
//         list.addAll(res.data['pois']);
//         loading = false;
//       });
//       if (query['page'] == 1) {
//         addressClick(list[0]);
//       }
//     });
//   }

//   /// 地址搜索
//   addressSearch(String tx) {
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//     query['page'] = 1;
//     query['keywords'] = tx;
//     setState(() {
//       list = [];
//     });
//     getList();
//   }

//   /// 地址选择
//   Map selectData = {};
//   addressClick(item) {
//     setState(() {
//       selectData = item;
//     });
//     widget.setAddress(item);
//   }

//   @override
//   void didUpdateWidget(covariant AddressPoiList oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.latLng != widget.latLng) {
//       query['page'] = 1;
//       setState(() {
//         list = [];
//       });
//       getList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Container(
//             width: 100,
//             height: 8,
//             margin: const EdgeInsets.only(top: 10),
//             decoration: BoxDecoration(
//               color: HexThemColor(backgroundColor),
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           input(),
//           Expanded(child: addressList())
//         ],
//       ),
//     );
//   }

//   Widget input() {
//     return Container(
//       height: 36.h,
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//       margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//       decoration: BoxDecoration(
//         color: HexThemColor(backgroundColor),
//         borderRadius: BorderRadius.circular(6.r),
//       ),
//       child: TextField(
//         keyboardType: TextInputType.multiline,
//         style: textStyle.copyWith(color: Colors.black),
//         textInputAction: TextInputAction.send,
//         textAlignVertical: TextAlignVertical.center, // 垂直居中对齐
//         decoration: InputDecoration(
//           isCollapsed: true,
//           hintText: '搜索地点位置',
//           hintStyle: textStyle,
//           border: InputBorder.none,
//           counterText: '',
//         ),
//         onSubmitted: addressSearch,
//         onChanged: (value) {
//           query['keywords'] = value;
//         },
//       ),
//     );
//   }

//   Widget addressList() {
//     if (loading && list.isEmpty) {
//       return const LoadingText();
//     }
//     if (list.isNotEmpty) {
//       return EasyRefresh(
//         onLoad: () {
//           query['page'] += 1;
//           getList();
//         },
//         child: ListView.builder(
//           itemCount: list.length,
//           padding: EdgeInsets.only(
//             bottom: ScreenUtil().bottomBarHeight,
//           ),
//           itemBuilder: (context, index) => itemBuild(list[index]),
//         ),
//       );
//     } else {
//       return SizedBox(
//         width: 200.r,
//         height: 200.r,
//         child: const NotDataIcon(
//           status: NetWorkDataStatus.notData,
//         ),
//       );
//     }
//   }

//   Widget itemBuild(item) {
//     return Container(
//       height: 64.h,
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.grey.shade200,
//           ),
//         ),
//       ),
//       child: ListTile(
//         selected: selectData.isNotEmpty && selectData['id'] == item['id'],
//         trailing: selectData.isNotEmpty && selectData['id'] == item['id']
//             ? const Icon(Icons.done_rounded)
//             : null,
//         contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
//         title: Text(item['name']),
//         subtitle: Text(item['address'] is String ? item['address'] : ''),
//         onTap: () {
//           addressClick(item);
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
