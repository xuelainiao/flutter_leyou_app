import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';

/// 是否生产模式
isProduction() {
  return const bool.fromEnvironment('dart.vm.product');
}

/// 底部弹窗菜单选择
showBottomMenu(List<Map<String, dynamic>> list, Function(dynamic) callback) {
  showModalBottomSheet(
    context: Get.context!,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
          padding: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...list.map(
                  (e) => InkWell(
                    onTap: () {
                      Get.back();
                      callback.call(e);
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: Text(e['title'], style: tx16),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 8,
                  color: Color.fromRGBO(241, 241, 241, 1),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                    callback.call("");
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    child: Text('取消', style: tx16),
                  ),
                ),
              ],
            ),
          ));
    },
  );
}
