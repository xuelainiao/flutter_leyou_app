import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/api/msg.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/utils/socket/event.dart';
import 'package:mall_community/utils/socket/socket.dart';

/// 前端自己维护的消息状态
enum CustomMsgStatus {
  /// 发送中
  sending,

  /// 发送成功
  success,

  /// 发送失败
  fail,
}

class ChatController extends GetxController {
  // 工具栏key
  UniqueKey toolBarKey = UniqueKey();
  // 发送框聚焦
  FocusNode textFocusNode = FocusNode();
  // 文本聚焦
  FocusNode textSelectFocusNode = FocusNode();
  // socket
  late SocketManager socket;
  // 标题
  final title = ''.obs;

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
          newMsgList.addAll(list.reversed);
        } else {
          msgHistoryList.addAll(list.reversed);
        }
      }
      loading.value = false;
    } finally {
      debugPrint('请求完毕');
      loading.value = false;
    }
  }

  ScrollController scrollControll = ScrollController();

  // 新消息数组
  final newMsgList = [].obs;
  // 引用消息回复消息
  Rx<SendMsgDto?> quoteMsg = Rx<SendMsgDto?>(null);

  /// 发送消息
  sendMsg(String msg, {String type = 'text'}) {
    Map msgData = {
      'content': msg,
      'userId': UserInfo.info['userId'],
      'friendId': params['friendId'],
      'messageType': type
    };
    var data = SendMsgDto(msgData, quote: quoteMsg.value);
    data.status = CustomMsgStatus.sending;
    socket.sendMessage(SocketEvent.friendMessage, data: data.toJson());
    newMsgList.add(data);
    toBottom();
  }

  /// 设置消息状态
  setMsgStatus(CustomMsgStatus status, msgTime) {
    int inx = newMsgList.indexWhere((item) => item.time == msgTime);
    if (inx != -1) {
      SendMsgDto newMsg = newMsgList[inx];
      newMsg.status = status;
      newMsgList[inx] = newMsg;
    }
  }

  /// 唤起键盘并且聚焦
  showInput() {
    SystemChannels.textInput.invokeMethod("TextInput.show");
    textFocusNode.requestFocus();
  }

  initEvent() {
    // 加入私聊成功
    socket.subscribe(SocketEvent.joinFriendSocket, (res) {});
    // 接收好友消息
    socket.subscribe(SocketEvent.friendMessage, (data) {
      Map? result = data['data'];
      if (result != null) {
        data = SendMsgDto(result);
      }
      if (data.userId == params['userId']) {
        newMsgList.add(data);
        toBottom();
      } else {
        setMsgStatus(CustomMsgStatus.success, data.time);
      }
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
    params['pageSize'] = 15;
    params['page'] = 0;
    title.value = params['userName'];
    socket = SocketManager(token: UserInfo.token);
    socket.sendMessage(
      SocketEvent.joinFriendSocket,
      data: {'friendId': params['friendId']},
    );
    // edbcba00-866f-4b3d-a7e5-e03ac352cab2
    initEvent();
    await getHistoryMsg();
  }

  @override
  void onClose() {
    closeEvent();
    super.onClose();
  }
}
