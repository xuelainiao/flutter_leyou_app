import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/easy_refresh_diy/easy_refresh_diy.dart';
import 'package:mall_community/pages/home/msg_list_page/components/friends.dart';
import 'package:mall_community/pages/home/msg_list_page/components/groups.dart';
import 'package:mall_community/pages/home/msg_list_page/components/top_bar.dart';
import 'package:mall_community/pages/home/msg_list_page/controller/msg_list_module.dart';
import 'package:mall_community/pages/home/msg_list_page/components/msg_list.dart';

///用户消息列表
class MsgListPage extends StatefulWidget {
  const MsgListPage({super.key});

  @override
  State<MsgListPage> createState() => _MsgListPageState();
}

class _MsgListPageState extends State<MsgListPage>
    with TickerProviderStateMixin {
  final MsgListModule chatController = Get.put(MsgListModule());
  late TabController tabController;
  final tabs = [
    {'text': "消息"},
    {'text': '联系人'},
    {'text': '我的群'}
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      chatController.easyRefreshController.resetFooter();
    });
    chatController.easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      onLoad: () {
        chatController.getMore(tabController.index);
      },
      footer: footerLoading,
      controller: chatController.easyRefreshController,
      childBuilder: (context, physics) {
        return ScrollConfiguration(
          behavior: const ERScrollBehavior(),
          child: ExtendedNestedScrollView(
            physics: physics,
            onlyOneScrollInBody: true,
            pinnedHeaderSliverHeightBuilder: () {
              return MediaQuery.of(context).padding.top + kToolbarHeight;
            },
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[TopBar(tabController: tabController, tabs: tabs)];
            },
            body: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: TabBarView(
                controller: tabController,
                children: [
                  FirendMsgList(physics: physics),
                  FriendList(physics: physics),
                  GroupList(physics: physics),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    tabController.removeListener(() {});
    super.dispose();
  }
}
