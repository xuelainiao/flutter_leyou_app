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

  /// 请求超时时间
  static Duration timeout = const Duration(seconds: 60);

  /// AppId
  static int appId = 10001;

  /// 端口ID
  static String portId = "6";

  /// 隐私政策是否同意
  static bool privacyStatementHasAgree = true;

  /// 百度地图 ios key
  static const String amapIosKey = "";

  /// 百度地图 android key
  static const String amapAndroidKey = "";

  /// 高德地图 web
  static const String amapWebkey = "";

  /// 极光推送 appkey
  static const String jPushKey = "";

  /// 极光推送注册id
  static String jPushId = '';

  /// 腾讯云 cos 秘钥id
  static String secretId = "";

  /// 腾讯云 cos 秘钥key
  static String secretKey = "";

  /// 键盘高度
  static double keyBoardHeight = 0.0;
}
