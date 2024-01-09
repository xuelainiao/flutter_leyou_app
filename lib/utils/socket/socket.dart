import 'package:mall_community/common/appConfig.dart';
import 'package:mall_community/modules/userModule.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();

  IO.Socket? _socket;

  /// 连接地址
  String socketUrl = AppConfig.baseUrl;

  /// 当前订阅消息事件
  List<String> subscribeList = [];

  factory SocketManager({required String userId}) {
    if (!_instance.isConnected) {
      _instance.init(userId: userId);
    }
    return _instance;
  }

  SocketManager._internal();

  void init({required String userId}) {
    if (userId.isEmpty) return;
    _socket = IO.io('$socketUrl/?userId=$userId', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket?.onConnect(onConnect);
    _socket?.onDisconnect(onDisconnect);
    _socket?.onConnectError((err) => {print("socket connectError $err")});
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
    if (_socket != null && _socket!.connected) {
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
      callback(data);
    });
  }

  ///清除订阅
  void unsubscribe(String event) {
    _socket?.off(event);
    subscribeList.remove(event);
  }

  /// 连接成功
  onConnect(e) {
    print('socket 连接成功$e');
  }

  /// 断开连接
  onDisconnect(e) {
    print('socket 断链 $e');
  }
}
