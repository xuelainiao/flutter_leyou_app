import 'dart:async';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/commStyle.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/components/AutomaticKeepAlive/AutomaticKeepAlive.dart';
import 'package:mall_community/components/Avatar/Avatar.dart';
import 'package:mall_community/components/Badge/Badge.dart';
import 'package:mall_community/components/NewWorkImageWidget/NewWorkImageWidget.dart';
import 'package:mall_community/components/Tabs/Tabs.dart';
import 'package:mall_community/modules/userModule.dart';
import 'package:mall_community/utils/socket/Event.dart';
import 'package:mall_community/utils/socket/socket.dart';

///用户消息列表
class MsgListPage extends StatefulWidget {
  const MsgListPage({super.key});

  @override
  State<MsgListPage> createState() => _MsgListPageState();
}

class _MsgListPageState extends State<MsgListPage>
    with TickerProviderStateMixin {
  SocketManager socketManager = SocketManager(userId: UserInfo.user['userId']);
  final tabs = [
    {'text': "消息"},
    {'text': '联系人'}
  ];
  late TabController tabController;

  List msgList = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);

    if (UserInfo.token.isEmpty) {
      Future.delayed(Duration.zero, () {
        BrnDialogManager.showSingleButtonDialog(context, label: "请先登录",
            onTap: () {
          Get.toNamed('/login');
        });
      });
    }

    socketManager.subscribe(SocketEvent.chatData, (res) {
      List groupMsg = res['data']['groupData'] ?? [];
      List msgDatas = res['data']?['friendData'] ?? [];
      for (Map item in groupMsg) {
        msgDatas.add({
          'groupId': item['groupId'],
          'userId': item['userId'],
          'username': item['groupName'],
          'avatar': item['avatar'],
          'messages':
              item.containsKey('messages') == true ? item['messages'] : []
        });
      }

      setState(() {
        msgList = msgDatas;
      });
    });

    Timer(const Duration(seconds: 1), () {
      socketManager.sendMessage(SocketEvent.chatData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyAutomaticKeepAlive(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(232, 225, 255, 1),
                  Colors.white,
                ],
                stops: [0.7, 1.0],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Tabs(
                          tabs: tabs,
                          tabController: tabController,
                          labelColor: primaryColor,
                          unselectedLabelColor: primaryNavColor,
                          indicator: const BoxDecoration(),
                          labelStyle: tx20.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(IconData(0xe6cb, fontFamily: 'micon')),
                      ),
                    ],
                  ),
                ),
                buildSearch()
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: ListView.builder(
                itemCount: msgList.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, i) => buildItem(i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: BrnSearchText(
        prefixIcon: Container(
          height: 44.h,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(
            IconData(0xe67e, fontFamily: 'micon'),
            size: 18,
            color: Colors.white,
          ),
        ),
        hintText: '搜索用户、群组',
        hintStyle: tx14.copyWith(color: placeholderTextC),
        outSideColor: Colors.transparent,
        innerPadding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(10),
        innerColor: primaryNavColor,
        onTextCommit: (valur) {},
      ),
    );
  }

  buildItem(int i) {
    return SwipeActionCell(
      key: ValueKey(i),
      trailingActions: getCellNav(i),
      child: ListTile(
        onTap: () {
          print(i);
        },
        leading: MyAvatar(
          src: msgList[i]['avatar'],
          radius: 50,
          size: 50.r,
          nums: msgList[i]?['online'] == 1 ? "1" : "",
        ),
        title: SizedBox(
          height: 28.h,
          child: Text(
            msgList[i]['username'],
            style: tx14.copyWith(
              color: primaryTextC,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: msgList[i]['messages'].length > 0
            ? Text(
                '${msgList[i]['messages'][0]['content']} · ${msgList[i]['messages'][0]['time']}',
                style: tx10.copyWith(color: secondaryTextC),
                maxLines: 1,
              )
            : const SizedBox(),
        trailing: MyBadge(value: msgList[i]['messages'].length),
      ),
    );
  }

  List<SwipeAction> getCellNav(i) {
    return [
      SwipeAction(
        title: "删除",
        onTap: (CompletionHandler handler) async {
          await handler(true);
          msgList.removeAt(i);
          setState(() {});
        },
        color: errorColor,
      ),
      SwipeAction(
        title: "置顶",
        onTap: (CompletionHandler handler) async {
          await handler(false);
        },
        color: warningColor,
      ),
    ];
  }
}
