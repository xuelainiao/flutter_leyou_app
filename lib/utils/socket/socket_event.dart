/// socket 事件订阅枚举
class SocketEvent {
  ///消息撤回
  static String revokeMessage = 'revokeMessage';

  ///添加好友
  static String addFriend = 'addFriend';

  ///加入私聊的socket连接
  static String joinFriendSocket = 'joinFriendSocket';

  ///发送私聊消息
  static String friendMessage = 'friendMessage';

  ///获取所有群和好友数据
  static String chatData = 'chatData';

  /// 加入群组
  static String joinGroup = 'joinGroup';

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
