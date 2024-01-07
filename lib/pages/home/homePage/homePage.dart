import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/commStyle.dart';
import 'package:mall_community/pages/home/homePage/HomeModule.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeModule homeModule = Get.put(HomeModule());

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
