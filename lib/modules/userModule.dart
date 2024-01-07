import 'package:mall_community/utils/storage.dart';

class UserInfo {
  static final UserInfo _userInfo = UserInfo._internal();

  factory UserInfo() {
    if (UserInfo.info.isEmpty) {
      UserInfo.info = Storage().read('user_info') ?? {};
    }
    if (UserInfo.token.isEmpty) {
      UserInfo.token = Storage().read('token') ?? '';
    }
    return _userInfo;
  }

  UserInfo._internal();

  /// 用户信息
  static Map info = {};

  /// 用户token
  static String token = '';

  static Map get user {
    if (UserInfo.info.isEmpty) {
      UserInfo.info = Storage().read('user_info') ?? {};
    }
    return UserInfo.info;
  }
}
