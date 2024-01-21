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

  static Map info = {};

  /// 用户token
  static String token = '';

  /// 用户信息
  static Map get user {
    if (UserInfo.info.isEmpty) {
      UserInfo.info = Storage().read('user_info') ?? {};
    }
    return UserInfo.info;
  }

  /// 当前用户是否是自己
  static bool isMy(String userId) {
    if (UserInfo.info.isEmpty) {
      UserInfo.info = Storage().read('user_info') ?? {};
    }
    return UserInfo.info['userId'] == userId;
  }
}
