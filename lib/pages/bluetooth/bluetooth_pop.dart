import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/pages/bluetooth/bluetooth_page.dart';
import 'package:mall_community/utils/log/log.dart';
import 'package:mall_community/utils/toast/toast.dart';

class BluetoohPop extends StatefulWidget {
  const BluetoohPop({super.key});

  @override
  State<BluetoohPop> createState() => _BluetoohPopState();
}

class _BluetoohPopState extends State<BluetoohPop> {
  late StreamSubscription<bool> _isScanningSubscription;
  List<ScanResult> _scanResults = [];
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  bool _isScanning = false;

  init() async {
    if (await FlutterBluePlus.isSupported == false) {
      ToastUtils.showToast("错误 当前设备不支持蓝牙");
      return;
    }

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      Log.error("扫描蓝牙设备错误  ￥e");
    });
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
    getDevices();
  }

  getDevices() async {
    debugPrint("开始扫描设备");
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      Log.error("Start Scan Error:$e");
    }
    if (mounted) {
      setState(() {});
    }
  }

  connecnt(BluetoothDevice device) async {
    try {
      Get.back(result: device);
    } catch (e) {
      Log.error(e);
    } finally {}
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      color: Colors.white,
      child: Column(
        children: [
          _isScanning
              ? const LoadingText(
                  text: "扫描中",
                )
              : const SizedBox(),
          Expanded(
            child: ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (ctx, i) {
                ScanResult item = _scanResults[i];
                return ScanResultTile(
                  result: item,
                  onTap: () {
                    connecnt(item.device);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () {
              connecnt(r.device);
            },
          ),
        )
        .toList();
  }
}
