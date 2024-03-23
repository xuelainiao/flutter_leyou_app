import 'package:mall_community/utils/storage.dart';

class UserInfo {
  static final UserInfo _userInfo = UserInfo._internal();

  factory UserInfo() {
    if (UserInfo._info.isEmpty) {
      UserInfo._info = Storage().read('user_info') ?? {};
    }
    if (UserInfo.token.isEmpty) {
      UserInfo.token = Storage().read('token') ?? '';
    }
    return _userInfo;
  }

  UserInfo._internal();

  static Map _info = {};

  /// 用户token
  static String token = '';

  /// 用户信息
  static Map get user {
    if (UserInfo._info.isEmpty) {
      UserInfo._info = Storage().read('user_info') ?? {};
    }
    return UserInfo._info;
  }

  static set setUser(Map user) {
    UserInfo._info = user;
  }

  /// 当前用户是否是自己
  static bool isMy(String userId) {
    if (UserInfo._info.isEmpty) {
      UserInfo._info = Storage().read('user_info') ?? {};
    }
    return UserInfo._info['userId'] == userId;
  }
}

class UserModule {}
