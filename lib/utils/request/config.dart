import 'package:mall_community/common/appConfig.dart';
import 'package:mall_community/utils/utils.dart';

class ApiConfig {
  static const int appId = 10001;

  static Duration timeoutSeconds = const Duration(seconds: 20);

  static Duration connectTimeout = const Duration(seconds: 20);

  static String baseUrl = AppConfig.baseUrl;

  // /// Go服务器 api
  // static String goBaseUrl = isProduction()
  //     ? 'https://psj.junwangfei.cn'
  //     : 'https://psjdev.t1.junwangfei.cn';
}
