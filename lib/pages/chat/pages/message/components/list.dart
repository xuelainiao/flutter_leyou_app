import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/message_box.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';

///好友聊天消息列表
class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ChatController chatController = Get.find();
  GlobalKey centerKey = GlobalKey();
  bool isToBottom = false;
  late Worker everCallBack;

  @override
  void initState() {
    super.initState();

    everCallBack = ever(chatController.newMsgList, (list) {
      msgNextTick();
      everCallBack.call();
    });
  }

  /// 首次监听消息列表渲染完毕
  msgNextTick() {
    if (chatController.params['page'] == 1 && !isToBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (chatController.params['page'] == 1 &&
            chatController.scrollControll.position.maxScrollExtent > 40) {
          isToBottom = true;
          chatController.toBottom();
        }
      });
    }
  }

  ///滚动监听
  scrollListener(ScrollMetrics metrics) {
    if (metrics.extentBefore < 50 &&
        metrics.axis == Axis.vertical &&
        metrics.extentAfter > chatController.extentAfter &&
        chatController.extentAfter > 50) {
      if (!chatController.loading.value && chatController.params['page'] >= 1) {
        chatController.getHistoryMsg();
      }
    }
    chatController.extentAfter = metrics.extentAfter;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollNotification) {
            if (notification.metrics is PageMetrics) {
              return false;
            }
            if (notification.metrics is FixedScrollMetrics) {
              if (notification.metrics.axisDirection == AxisDirection.left ||
                  notification.metrics.axisDirection == AxisDirection.right) {
                return false;
              }
            }
            scrollListener(notification.metrics);
          }
          return false;
        },
        child: GestureDetector(
          onVerticalDragDown: (de) {
            OverlayManager().removeOverlay(chatController.toolBarKey);
            MsgBotInputModule.hideBootoMenu();
          },
          child: Container(
            color: AppTheme.mode == ThemeMode.dark ? null : cF1f1f1,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Stack(
              children: [
                CustomScrollView(
                  controller: chatController.scrollControll,
                  center: centerKey,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    Obx(() {
                      if (!chatController.loading.value) {
                        return const SliverPadding(
                          padding: EdgeInsets.all(0),
                        );
                      } else {
                        return const SliverToBoxAdapter(child: LoadingText());
                      }
                    }),
                    Obx(() {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            return buildItem(chatController.msgHistoryList[i]);
                          },
                          childCount: chatController.msgHistoryList.length,
                        ),
                      );
                    }),
                    SliverPadding(
                      padding: EdgeInsets.zero,
                      key: centerKey,
                    ),
                    Obx(() {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            return buildItem(chatController.newMsgList[i]);
                          },
                          childCount: chatController.newMsgList.length,
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(SendMsgDto item) {
    bool isMy = chatController.isMy(item.userId);
    return MessageBox(
      isMy: isMy,
      avatar: isMy ? UserInfo.user['avatar'] : chatController.params['avatar'],
      item: item,
      toolBarKey: chatController.toolBarKey,
    );
  }
}
