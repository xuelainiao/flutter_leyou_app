/// socket 事件订阅枚举
class SocketEvent {
  ///消息撤回
  static String revokeMessage = 'revokeMessage';

  ///添加好友
  static String addFriend = 'addFriend';

  ///加入私聊的socket连接
  static String joinFriendSocket = 'joinFriendSocket';

  ///发送私聊消息
  static const String friendMessage = 'friendMessage';

  /// 拨打电话
  static const String callPhone = "callPhone";

  /// 接听电话
  static const String answerPhone = "answerPhone";

  /// 拒接电话
  static const String rejectPhone = "rejectPhone";

  /// 拨打电话对方未接听
  static const String noAnswerPhone = "noAnswerPhone";

  /// 通话挂断
  static const String hangUpPhone = "hangUpPhone";

  /// ice候选人交换
  static const String iceCandidate = "iceCandidate";

  /// webrtc offer 发送
  static const String rtcOffer = "rtcOffer";

  /// webrtc Answer 发送
  static const String rtcAnswer = "rtcAnswer";

  /// 视频通话画面关闭
  static const String cameraClose = "cameraClose";

  ///获取所有群和好友数据
  static const String chatData = 'chatData';

  /// 加入群组
  static const String joinGroup = 'joinGroup';

  /// 创建群组
  static String addGroup = 'addGroup';

  ///加入群组的socket连接
  static String joinGroupSocket = 'joinGroupSocket';

  ///发送群消息
  static String groupMessage = 'groupMessage';

  ///退群
  static String exitGroup = 'exitGroup';

  ///更新群信息(公告,群名)
  static String updateGroupInfo = 'updateGroupInfo';

  ///邀请好友入群
  static String inviteFriendsIntoGroup = 'inviteFriendsIntoGroup';

  /// 删好友
  static String exitFriend = 'exitFriend';

  ///更新用户信息(头像\用户名)
  static String updateUserInfo = 'updateUserInfo';

  ///用户下线
  static String userOffline = 'userOffline';

  ///用户上线
  static String userOnline = 'userOnline';
}
