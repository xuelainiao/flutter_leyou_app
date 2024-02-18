import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/api/msg.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/utils/socket/socket_event.dart';
import 'package:mall_community/utils/socket/socket.dart';
import 'package:mall_community/utils/utils.dart';

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
  ScrollController scrollControll = ScrollController();
  // 工具栏key
  UniqueKey toolBarKey = UniqueKey();
  // 发送框聚焦
  FocusNode textFocusNode = FocusNode();
  // 文本选择聚焦
  FocusNode textSelectFocusNode = FocusNode();
  // socket
  late SocketManager socket;
  // 标题
  final title = ''.obs;
  // 是否处于底部
  RxBool isBottom = true.obs;
  // 消息是否超出一屏
  RxBool listRxceed = false.obs;

  // 历史消息
  final msgHistoryList = [].obs;
  var params = {};
  int total = 0;
  final loading = false.obs;

  /// 获取历史消息
  getHistoryMsg() async {
    try {
      params['page'] += 1;
      loading.value = true;
      var result = await reqMessages(params);
      total = result.data['total'];
      if (result.data['list'].length > 0) {
        List list =
            result.data['list'].map((item) => SendMsgDto(item)).toList();
        msgHistoryList.addAll(list);
      }
      loading.value = false;
    } finally {
      debugPrint('请求完毕');
      loading.value = false;
    }
  }

  // 新消息数组
  final newMsgList = [].obs;
  // 新消息数量
  RxInt newMsgNums = 0.obs;
  // 引用消息回复消息
  Rx<SendMsgDto?> quoteMsg = Rx<SendMsgDto?>(null);

  /// 发送消息
  void sendMsg(String msg, {String type = 'text'}) {
    Map msgData = {
      'content': msg,
      'userId': UserInfo.info['userId'],
      'friendId': params['friendId'],
      'messageType': type
    };
    var data = SendMsgDto(msgData, quote: quoteMsg.value);
    data.status = CustomMsgStatus.sending;
    socket.sendMessage(SocketEvent.friendMessage, data: data.toJson());
    addMsg(data);
  }

  /// 追加消息
  void addMsg(SendMsgDto data) {
    newMsgList.add(data);
    if (isBottom.value) {
      toBottom();
    } else {
      newMsgNums.value += 1;
    }
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
        addMsg(data);
      } else {
        setMsgStatus(CustomMsgStatus.success, data.time);
      }
    });
    // 消息撤回
  }

  void closeEvent() {
    socket.unSubscribe(SocketEvent.joinFriendSocket);
    socket.unSubscribe(SocketEvent.friendMessage);
  }

  ///是否是自己
  bool isMy(String userId) {
    return userId == UserInfo.user['userId'];
  }

  /// 滚动到底部
  void toBottom({bool isNext = true}) {
    if (isNext) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        double height = scrollControll.position.maxScrollExtent;
        scrollControll.animateTo(
          height,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    } else {
      double height = scrollControll.position.maxScrollExtent;
      scrollControll.animateTo(
        height,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  /// 键盘检测
  late StreamSubscription<bool> keyboardSubscription;

  GlobalKey key2 = GlobalKey();

  RxDouble offSet = 0.0.obs;
  GlobalKey listKey = GlobalKey();

  /// 消息列表超出屏幕检测
  checkListExceed() {
    double extentTotal = scrollControll.position.extentTotal;
    double extentInside = scrollControll.position.extentInside;
    offSet.value =(scrollControll.position.extentBefore) /  extentInside;
  }

  /// 列表滚动监听
  _scrollListener() {
    double extentAfter = scrollControll.position.extentAfter;
    double extentBefore = scrollControll.position.extentBefore;
    if (extentBefore == 0) {
      if (!loading.value && params['page'] >= 1) {
        getHistoryMsg();
      }
    }
    if (extentAfter > 800 && isBottom.value) {
      isBottom.value = false;
    }
    if (extentBefore >= scrollControll.position.maxScrollExtent &&
        !isBottom.value) {
      isBottom.value = true;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    scrollControll.addListener(_scrollListener);
    params = Get.arguments;
    params['friendId'] = params['userId'];
    params['pageSize'] = 15;
    params['page'] = 0;
    title.value = params['userName'];
    socket = SocketManager(token: UserInfo.token);
    socket.addRoom(params['friendId']);
    initEvent();
    await getHistoryMsg();
  }

  @override
  void onClose() {
    scrollControll.removeListener(_scrollListener);
    closeEvent();
    super.onClose();
  }
}
