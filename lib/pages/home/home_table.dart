import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mall_community/components/tabbar/tabbar.dart';
import 'package:mall_community/pages/home/msg_list_page/msg_list_page.dart';
import 'package:mall_community/pages/home/user/user.dart';

/// 首页 table page
class HomeTabblePage extends StatefulWidget {
  const HomeTabblePage({super.key});

  @override
  State<HomeTabblePage> createState() => _HomeTabblePageState();
}

class _HomeTabblePageState extends State<HomeTabblePage>
    with TickerProviderStateMixin {
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
      'page': () => const MsgListPage()
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
