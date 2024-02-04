import 'package:get/get.dart';
import 'package:mall_community/pages/chat/pages/message/message.dart';
import 'package:mall_community/pages/home/home_table.dart';
import 'package:mall_community/pages/login/login.dart';
import 'package:mall_community/pages/map_search/map_search.dart';
import 'package:mall_community/pages/preview_image/preview_image.dart';
import 'package:mall_community/pages/preview_video/preview_video.dart';
import 'package:mall_community/pages/privacy_statement/privacy_statement.dart';

class AppPages {
  static final List<GetPage> pages = [
    // 首页
    GetPage(name: '/home', page: () => const HomeTabblePage()),
    GetPage(name: '/login', page: () => LoginPage()),

    GetPage(
      name: '/privacyStatement',
      page: () => const PrivacyStatementPage(),
    ),

    // 好友模块
    GetPage(name: '/chat', page: () => MessageListPage()),

    // 图片预览
    GetPage(
      name: '/previewImage',
      page: () => const PreviewImage(),
      opaque: false,
      showCupertinoParallax: false,
      transition: Transition.noTransition,
    ),

    // 视频预览
    GetPage(
      name: '/previewVideo',
      page: () => const PreviewVideo(),
      transition: Transition.fade,
    ),

    // 地图
    GetPage(name: '/map', page: () => const ShowMapPage()),
  ];
}
