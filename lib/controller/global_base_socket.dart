import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/components/ring_call_pop.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/utils/event_bus/event_bus.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/socket/socket.dart';
import 'package:mall_community/utils/socket/socket_event.dart';

/// 全局基础 socket 控制器
/// 主要做一位消息全局展示或者全局消息弹窗这些
class BaseSocket extends GetxController {
  late SocketManager socket;

  initCallBack(res) {}

  /// 发送消息
  /// 并且返回格式化后的消息
  SendMsgModule sendMsg(
    String msg, {
    required String toUserId,
    String type = 'text',
    SendMsgModule? quoteMsg,
    String? socketEventType,
  }) {
    Map msgData = {
      'content': msg,
      'userId': UserInfo.user['userId'],
      'friendId': toUserId,
      'messageType': type
    };

    var data = SendMsgModule(msgData, quote: quoteMsg);
    data.status = CustomMsgStatus.sending;
    socket.sendMessage(
      socketEventType ?? SocketEvent.friendMessage,
      data: data.toJson(),
    );
    return data;
  }

  // 来电通知
  UniqueKey callPopKey = UniqueKey();
  callPhoneEvent(dynamic data) {
    if (data.containsKey("data")) {
      CallVideoMsg d = CallVideoMsg(data['data']);
      if (d.toUserId == UserInfo.user['userId']) {
        OverlayManager().showOverlay(
          RingCallPop(
            data: d,
            uniK: callPopKey,
          ),
          callPopKey,
          alignment: Alignment.topCenter,
        );
      }
    }
  }

  // 电话挂断 关闭来电通知 或者通知其他页面 比如 webrtc
  hangUpPhoneEvent(data) {
    if (data['code'] == 200) {
      CallVideoMsg msg = CallVideoMsg(data['data']);
      if (UserInfo.isMy(msg.toUserId)) {
        OverlayManager().removeOverlay(callPopKey);
      }
      EventBus.fire(SocketEvent.hangUpPhone, msg.toMap());
    }
  }

  @override
  void onInit() {
    socket = SocketManager(
      token: UserInfo.token,
      initCallBack: initCallBack,
    );
    socket.subscribe(SocketEvent.callPhone, callPhoneEvent);
    socket.subscribe(SocketEvent.hangUpPhone, hangUpPhoneEvent);
    super.onInit();
  }

  @override
  void onClose() {
    socket.unSubscribe(SocketEvent.callPhone);
    socket.disconnect();
    super.onClose();
  }
}

enum BaseSocketEvent {
  /// 电话挂断
  hangUpPhoneEvent
}
