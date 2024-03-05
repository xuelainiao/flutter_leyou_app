import 'package:mall_community/utils/utils.dart';

class AppConfig {
  /// 请求地址
  static String baseUrl =
      isProduction() ? 'http://8.138.91.219:3000' : 'http://8.138.91.219:3000';

  /// Go服务器 api
  static String goBaseUrl = isProduction()
      ? 'https://psj.junwangfei.cn'
      : 'https://psjdev.t1.junwangfei.cn';

  /// wss 直播链接地址
  static String liveWss = isProduction()
      ? 'wss://live.gyl.junwangfei.cn/ws'
      : 'wss://live.gyl.junwangfei.cn/ws';

  /// oss 资源前缀
  static String ossPath =
      "https://public-1259264706.cos.ap-guangzhou.myqcloud.com/";

  // /// socket 地址
  // static String socketUrl = isProduction()
  //     ? 'http://192.168.163.111:3000/socket'
  //     : 'http://192.168.163.111:3000/socket';

  /// 请求超时时间
  static Duration timeout = const Duration(seconds: 60);

  /// AppId
  static int appId = 10001;

  /// 端口ID
  static String portId = "6";

  /// 隐私政策是否同意
  static bool privacyStatementHasAgree = true;

  /// 高德地图 ios key
  static const String amapIosKey = "b14e65b23c1df6e6baa7453e689162ff";

  /// 高德地图 android key
  static const String amapAndroidKey = "7d434952c4abaeff7dccd09c73d2b0a7";

  /// 高德地图 web
  static const String amapWebkey = "e7cb1a7b75b3b535ebece65ea4c64386";

  /// 极光推送 appkey
  static const String jPushKey = "20552160646e55d1b65abdac";

  /// 极光推送注册id
  static String jPushId = '';

  /// 腾讯云 cos 秘钥id
  static String secretId = "AKIDpaCRXSFtR0Ris12vkXGmIxX1JPK6lIj3";

  /// 腾讯云 cos 秘钥key
  static String secretKey = "Rlx7FEF9ulcepyAD64DUeu5Rio4R4oXJ";

  //用于跳转H5链接，增加平台参数，用于屏蔽H5的字眼
  static const String loginPath = '/user/pages/user/login?psj_platform=APP';

  /// 盘世界H5
  static String psjH5 = isProduction()
      ? "https://psj.junwangfei.cn/h5"
      : "https://192.168.110.152:8080/h5";

  /// 键盘高度
  static double keyBoardHeight = 0.0;
}
