import 'dart:async';

import 'package:get/get.dart';
import 'package:mall_community/modules/userModule.dart';

class HomeModule extends GetxController {
  @override
  onInit() {
    super.onInit();
    print(UserInfo.token);
    // if (UserInfo.token.isEmpty) {
    //   Get.toNamed('/login');
    // }
    Timer(Duration(seconds: 1), () {
      Get.toNamed('/login');
    });
  }
}
