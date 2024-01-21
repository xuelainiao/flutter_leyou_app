import 'package:get/get.dart';
import 'package:mall_community/pages/chat/pages/message/message.dart';
import 'package:mall_community/pages/home/home_table.dart';
import 'package:mall_community/pages/login/login.dart';
import 'package:mall_community/pages/privacy_statement/privacy_statement.dart';

class AppPages {
  static final List<GetPage> pages = [
    /// 首页
    GetPage(name: '/home', page: () => const HomeTabblePage()),
    GetPage(name: '/login', page: () => LoginPage()),

    /// 地图
    // GetPage(name: '/map', page: () => ShowMapPage()),
    GetPage(
      name: '/privacyStatement',
      page: () => const PrivacyStatementPage(),
    ),

    /// 好友模块
    GetPage(name: '/chat', page: () => MessageListPage()),

    /// 图片预览
    // GetPage(
    //   name: '/previewImage',
    //   page: () => const PreviewImage2(),
    //   opaque: false,
    //   showCupertinoParallax: false,
    //   transition: Transition.noTransition,
    // ),
  ];
}
