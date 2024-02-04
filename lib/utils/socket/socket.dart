import 'package:flutter/widgets.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();

  io.Socket? _socket;

  /// 连接地址
  String socketUrl = AppConfig.baseUrl;

  /// 错误回调
  Function? _initCallBack;

  /// 当前订阅消息事件
  List<String> subscribeList = [];

  ///当前消息发送缓存队列
  List<Map<String, dynamic>> emits = [];

  ///状态 -1 待链接 0 连接中 1 已连接 2 已断开
  int _status = -1;

  factory SocketManager({String? token, Function? initCallBack}) {
    if (!_instance.isConnected) {
      _instance.init(token: token, initCallBack: initCallBack);
    }
    return _instance;
  }

  SocketManager._internal();

  void init({String? token, initCallBack}) {
    if (token == null || token.isEmpty || _status == 0) return;
    _status = 0;
    _socket = io.io('$socketUrl/?token=$token', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'header': {
        'authorization': token,
      }
    });
    _initCallBack = initCallBack;
    _socket?.onConnect(onConnect);
    _socket?.onDisconnect(onDisconnect);
    _socket?.onConnectError((err) {
      debugPrint('socket 连接错误 $err');
      _status = 2;
    });

    /// 自动注册 error 事件， 用于服务端校验信息等失败情况
    /// 当这个 error 被服务端主动触发 代表已经被服务端踢下线
    _socket?.on('error', (data) {
      _initCallBack?.call(data);
      int code = data['code'];
      _status = 2;
      switch (code) {
        /// 未登录  调用者页面自行处理
        /// IM 是进入app就初始化 所以理论在页面显示的时候 开发者就知道是否登录
        case 401:
          break;
        default:
      }
    });
  }

  bool get isConnected {
    return _socket?.connected ?? false;
  }

  /// 手动连接 暂时不用
  void connect() {
    if (_socket != null && !_socket!.connected) {
      _socket!.connect();
    }
  }

  /// 断开连接
  void disconnect() {
    _socket?.dispose();
  }

  /// 发送消息
  void sendMessage(String event, {dynamic data}) {
    // 有时会 socekt 还在连接中，但是用户已经调用了发送消息
    // 这时候就需要把消息缓存起来，等连接成功后再发送
    if (_socket == null || _status != 1) {
      emits.add({
        'event': event,
        'data': data,
      });
      return;
    }
    if (_socket!.connected) {
      data ??= {};
      data['token'] = UserInfo.token;
      _socket!.emit(event, data);
    }
  }

  /// 消息事件订阅
  void subscribe(String event, Function(dynamic) callback) {
    if (subscribeList.contains(event)) {
      return;
    }
    subscribeList.add(event);
    _socket?.on(event, (data) {
      if (data['code'] == 200) {
        callback(data);
      }
    });
  }

  ///清除订阅
  void unSubscribe(String event) {
    _socket?.off(event);
    subscribeList.remove(event);
  }

  /// 连接成功
  onConnect(e) {
    debugPrint('socket 连接成功$e');
    _status = 1;
    if (emits.isNotEmpty) {
      for (var item in emits) {
        sendMessage(item['event'], data: item['data']);
      }
      emits.clear();
    }
  }

  /// 断开连接
  onDisconnect(e) {
    debugPrint('socket 断链 $e');
    _status = 2;
  }
}
