import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/home/home_page/home_module.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeModule homeModule = Get.put(HomeModule());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text(
          '首页',
          style: tx20.copyWith(color: primaryNavColor),
        ),
      ),
    );
  }
}
