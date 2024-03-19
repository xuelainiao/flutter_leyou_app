import 'package:get/get.dart';
import 'package:mall_community/pages/chat/pages/message/message.dart';
import 'package:mall_community/pages/home/home_table.dart';
import 'package:mall_community/pages/login/login.dart';
import 'package:mall_community/pages/map_search/map_search.dart';
import 'package:mall_community/pages/privacy_statement/privacy_statement.dart';

import '../pages/chat/pages/call_video/call_video.dart';

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
    GetPage(name: '/chat', page: () => MessageListPage(), children: [
      GetPage(name: "/call_video", page: () => const CallVieoPage())
    ]),

    // 地图
    GetPage(name: '/map', page: () => const MapPage()),
  ];
}
