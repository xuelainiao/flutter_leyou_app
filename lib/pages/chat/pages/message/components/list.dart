import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/pages/chat/module/chat_module.dart';
import 'package:mall_community/pages/chat/pages/message/components/message_box.dart';

///好友聊天消息列表
class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ChatModule chatModule = Get.find();
  GlobalKey centerKey = GlobalKey();
  bool isToBottom = false;
  late Worker everCallBack;

  @override
  void initState() {
    super.initState();

    everCallBack = ever(chatModule.newMsgList, (list) {
      msgNextTick();
      everCallBack.call();
    });
  }

  /// 首次监听消息列表渲染完毕
  msgNextTick() {
    if (chatModule.params['page'] == 1 && !isToBottom) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (chatModule.params['page'] == 1 &&
            chatModule.scrollControll.position.maxScrollExtent > 40) {
          isToBottom = true;
          chatModule.toBottom();
        }
      });
    }
  }

  ///滚动监听
  scrollListener(ScrollMetrics metrics) {
    if (metrics.extentBefore < 50 &&
        metrics.axis == Axis.vertical &&
        metrics.extentAfter > chatModule.extentAfter &&
        chatModule.extentAfter > 50) {
      if (!chatModule.loading.value && chatModule.params['page'] >= 1) {
        chatModule.getHistoryMsg();
      }
    }
    chatModule.extentAfter = metrics.extentAfter;
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
        child: Container(
          color: AppTheme.mode == ThemeMode.dark ? null : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Stack(
            children: [
              CustomScrollView(
                controller: chatModule.scrollControll,
                center: centerKey,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  Obx(() {
                    if (!chatModule.loading.value) {
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
                          return buildItem(chatModule.msgHistoryList[i]);
                        },
                        childCount: chatModule.msgHistoryList.length,
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
                          return buildItem(chatModule.newMsgList[i]);
                        },
                        childCount: chatModule.newMsgList.length,
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  buildItem(SendMsgDto item) {
    bool isMy = chatModule.isMy(item.userId);
    return MessageBox(
      isMy: isMy,
      avatar: isMy ? UserInfo.user['avatar'] : chatModule.params['avatar'],
      item: item,
    );
  }
}
