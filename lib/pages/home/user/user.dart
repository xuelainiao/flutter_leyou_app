import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/pages/home/user/module/user_module.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key});

  final UserModule userModule = Get.put(UserModule());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button(
            text: "退出登录",
            onPressed: () {
              userModule.loginOut();
            })
      ],
    );
  }
}
