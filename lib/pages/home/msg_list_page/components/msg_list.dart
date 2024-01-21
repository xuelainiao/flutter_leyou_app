import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/automatic_keep_alive/automatic_keep_alive.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/home/msg_list_page/module/msg_list_module.dart';
import 'package:mall_community/utils/time.dart';

///好友消息列表
class FirendMsgList extends StatelessWidget {
  FirendMsgList({super.key, required this.physics});
  final ScrollPhysics physics;
  final MsgListModule msgListModule = Get.find();

  @override
  Widget build(BuildContext context) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('msgList'),
      child: MyAutomaticKeepAlive(
        child: LoadingPage(
          fetch: msgListModule.getMsgList,
          empty: '还没有人给你发消息呢~',
          child: Obx(
            () => ListView.builder(
              physics: physics,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              itemCount: msgListModule.msgList.length,
              itemBuilder: (ctx, i) => buildItem(i),
            ),
          ),
        ),
      ),
    );
  }

  buildItem(int i) {
    Map msg = msgListModule.msgList[i];
    // 这里的 user 是对方的信息
    Map user = UserInfo.isMy(msg['userId']) ? msg['toUser'] : msg['user'];

    return SwipeActionCell(
      key: ValueKey(i),
      trailingActions: getCellNav(i),
      child: ListTile(
          onTap: () {
            msgListModule.toChat(user);
          },
          leading: MyAvatar(
            src: user['avatar'],
            radius: 50,
            size: 50.r,
            nums: user['online'] == 1 ? "1" : "",
          ),
          title: SizedBox(
            height: 28.h,
            child: Text(
              user['userName'],
              style: tx14.copyWith(
                color: primaryTextC,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  msg['content'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tx12.copyWith(
                    color: HexThemColor(primaryTextC, direction: 2),
                  ),
                ),
              ),
              Text(
                TimeUtil.formatTime(msg['time']),
                style: tx12.copyWith(
                  color: HexThemColor(primaryTextC, direction: 2),
                ),
              ),
            ],
          )
          // trailing: MyBadge(value: msg['content'].length),
          ),
    );
  }

  List<SwipeAction> getCellNav(i) {
    return [
      SwipeAction(
        title: "删除",
        onTap: (CompletionHandler handler) async {
          await handler(true);
          // msgList.removeAt(i);
          // setState(() {});
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
