import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input/bottom_input.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/message_box.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

///好友聊天消息列表
class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ChatController chatController = Get.find();
  GlobalKey centerKey = GlobalKey();
  UniqueKey visKey = UniqueKey();
  late Worker everCallBack;

  // 首次监听消息列表渲染完毕
  _msgNextTick() {
    if (chatController.params['page'] == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatController.checkListExceed();
      });
    }
  }

  // 消息区域点击
  _listClick() {
    chatController.textSelectFocusNode.unfocus();
    OverlayManager().removeOverlay(chatController.toolBarKey);
    MsgBotInputModule.hideBootoMenu();
  }

  @override
  void initState() {
    super.initState();

    everCallBack = ever(chatController.msgHistoryList, (list) {
      _msgNextTick();
      everCallBack.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (de) {
        _listClick();
      },
      child: Container(
        color: AppTheme.mode == ThemeMode.dark ? null : cF1f1f1,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        alignment: Alignment.topCenter,
        child: Obx(
          () => CustomScrollView(
            reverse: true,
            anchor: 0,
            controller: chatController.scrollControll,
            center: chatController.listRxceed.value ? centerKey : null,
            shrinkWrap: chatController.listRxceed.value ? false : true,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return buildItem(chatController.newMsgList[i]);
                  },
                  childCount: chatController.newMsgList.length,
                ),
              ),
              SliverPadding(padding: EdgeInsets.zero, key: centerKey),
              SliverList(
                key: chatController.key2,
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return buildItem(chatController.msgHistoryList[i], i: i);
                  },
                  childCount: chatController.msgHistoryList.length,
                ),
              ),
              Obx(() {
                if (!chatController.loading.value) {
                  return const SliverPadding(
                    padding: EdgeInsets.all(0),
                  );
                } else {
                  return const SliverToBoxAdapter(child: LoadingText());
                }
              }),
              if (chatController.loading.value)
                const SliverToBoxAdapter(child: LoadingText())
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(SendMsgDto item, {int? i}) {
    bool isMy = chatController.isMy(item.userId);
    // 这里监听第一个消息 是否超出屏幕 性能不用担心
    if (i != null && i == chatController.msgHistoryList.length - 1) {
      return VisibilityDetector(
        key: visKey,
        child: MessageBox(
          isMy: isMy,
          avatar:
              isMy ? UserInfo.user['avatar'] : chatController.params['avatar'],
          item: item,
          toolBarKey: chatController.toolBarKey,
        ),
        onVisibilityChanged: (VisibilityInfo state) {
          if (state.visibleFraction < 1) {
            chatController.listRxceed.value = true;
          }else {
            chatController.listRxceed.value = false;

          }
        },
      );
    } else {
      return MessageBox(
        isMy: isMy,
        avatar:
            isMy ? UserInfo.user['avatar'] : chatController.params['avatar'],
        item: item,
        toolBarKey: chatController.toolBarKey,
      );
    }
  }
}
