import 'package:get/get.dart';
import 'package:mall_community/utils/storage.dart';

class UserModule extends GetxController {
  /// 退出登录
  loginOut() {
    Storage().remove('token');
    Storage().remove('user_info');
    Get.toNamed('/login');
  }
}
