import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mall_community/common/commStyle.dart';
import 'package:mall_community/components/tabbar/tabbar.dart';
import 'package:mall_community/modules/userModule.dart';
import 'package:mall_community/pages/home/msgListPage/msgListPage.dart';
import 'package:mall_community/pages/home/user/user.dart';
import 'package:mall_community/utils/socket/Event.dart';
import 'package:mall_community/utils/socket/socket.dart';
import 'homePage/homePage.dart';

/// 首页 table page
class HomeTabblePage extends StatefulWidget {
  const HomeTabblePage({super.key});

  @override
  State<HomeTabblePage> createState() => _HomeTabblePageState();
}

class _HomeTabblePageState extends State<HomeTabblePage>
    with TickerProviderStateMixin {
  SocketManager socketManager = SocketManager(userId: UserInfo.user['userId']);

  int index = 0;
  late TabController tabController;
  List pageList = [
    {
      'name': '消息',
      'icon': const Icon(FontAwesomeIcons.message),
      'activeIcon': Lottie.asset(
        'lib/assets/lottie/home_msg.json',
        repeat: false,
      ),
      'page': () => MsgListPage()
    },
    {
      'name': '我的',
      'icon': const Icon(FontAwesomeIcons.user),
      'activeIcon': Lottie.asset(
        'lib/assets/lottie/home_user.json',
        repeat: false,
      ),
      'page': () => UserPage()
    },
    {
      'name': '我的',
      'icon': const Icon(FontAwesomeIcons.user),
      'activeIcon': Lottie.asset(
        'lib/assets/lottie/home_user.json',
        repeat: false,
      ),
      'page': () => UserPage()
    },
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: pageList.length,
      vsync: this,
      animationDuration: const Duration(milliseconds: 0),
    );
  }

  barTap(int inx) {
    setState(() {
      index = inx;
    });
    tabController.index = inx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: List.generate(
            pageList.length,
            (i) => pageList[i]['page'].call(),
          )),
      bottomNavigationBar: TabBare(
        tabs: pageList,
        onTap: barTap,
        curr: index,
      ),
    );
  }
}
