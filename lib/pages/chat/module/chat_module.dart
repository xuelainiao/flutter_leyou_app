import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/api/msg.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/utils/socket/event.dart';
import 'package:mall_community/utils/socket/socket.dart';

class ChatModule extends GetxController {
  late SocketManager socket;
  final title = ''.obs;
  String avatar =
      'https://public-1259264706.cos.ap-guangzhou.myqcloud.com/flutter_app%2Fuser%2Fuser_avatar_0_02.png';

  /// 消息列表
  final msgHistoryList = [].obs;
  var params = {};
  int total = 0;
  final loading = false.obs;
  getHistoryMsg() async {
    try {
      params['page'] += 1;
      loading.value = true;
      var result = await reqMessages(params);
      total = result.data['total'];
      if (result.data['list'].length > 0) {
        List list =
            result.data['list'].map((item) => SendMsgDto(item)).toList();
        if (params['page'] == 1) {
          newMsgList.addAll(list);
        } else {
          msgHistoryList.addAll(list);
        }
      }
      loading.value = false;
    } finally {
      debugPrint('请求完毕');
      loading.value = false;
    }
  }

  ScrollController scrollControll = ScrollController();

  /// 发送消息
  final newMsgList = [].obs;
  sendMsg(String msg, {String type = 'text'}) {
    var data = SendMsgDto({
      'content': msg,
      'userId': UserInfo.info['userId'],
      'friendId': params['friendId'],
      'messageType': type,
    });
    socket.sendMessage(SocketEvent.friendMessage, data: data.toJson());
    newMsgList.add(data);
    toBottom();
  }

  initEvent() {
    // 加入私聊成功
    socket.subscribe(SocketEvent.joinFriendSocket, (res) {
      debugPrint('加入私聊成功 $res');
    });
    // 接收群消息
    socket.subscribe(SocketEvent.friendMessage, (data) {
      // msgList.insert(0, data);
    });
    // 消息撤回
  }

  closeEvent() {
    socket.unSubscribe(SocketEvent.joinFriendSocket);
    socket.unSubscribe(SocketEvent.friendMessage);
  }

  ///是否是自己
  isMy(String userId) {
    return userId == UserInfo.user['userId'];
  }

  /// 是否处于底部
  double extentAfter = 0.0;

  /// 滚动到底部
  toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double height = scrollControll.position.maxScrollExtent;
      scrollControll.animateTo(
        height,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  /// 键盘检测
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void onInit() async {
    super.onInit();
    params = Get.arguments;
    params['friendId'] = params['userId'];
    params['pageSize'] = 20;
    params['page'] = 0;
    title.value = params['userName'];
    socket = SocketManager(token: UserInfo.token);
    socket.sendMessage(
      SocketEvent.joinFriendSocket,
      data: {'friendId': params['friendId']},
    );
    initEvent();
    await getHistoryMsg();
  }

  @override
  void onClose() {
    closeEvent();
    super.onClose();
  }
}
