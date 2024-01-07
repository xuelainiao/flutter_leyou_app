import 'package:get/get.dart';
import 'package:mall_community/pages/home/homePage/homePage.dart';
import 'package:mall_community/pages/home/homeTable.dart';
import 'package:mall_community/pages/login/login.dart';
import 'package:mall_community/pages/privacyStatement/privacyStatement.dart';

class AppPages {
  static final List<GetPage> pages = [
    /// 首页
    GetPage(name: '/home', page: () => HomeTabblePage()),
    GetPage(name: '/login', page: () => LoginPage()),

    /// 地图
    // GetPage(name: '/map', page: () => ShowMapPage()),
    GetPage(
        name: '/privacyStatement', page: () => const PrivacyStatementPage()),

    // GetPage(
    //   name: '/previewImage',
    //   page: () => const PreviewImage2(),
    //   opaque: false,
    //   showCupertinoParallax: false,
    //   transition: Transition.noTransition,
    // ),
  ];
}
