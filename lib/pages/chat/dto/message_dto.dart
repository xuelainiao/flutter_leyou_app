/// Im消息DTO
class SendMsgDto {
  /// 消息体
  late String content;

  /// 好友ID
  late String friendId;

  /// 用户ID
  late String userId;

  /// 消息类型
  late String messageType;

  /// 文件宽 针对图片类型
  int? width;

  /// 文件高 针对图片类型
  int? height;

  /// 当前时间戳
  int? time;

  /// 文件名
  String? fileName;

  /// 文件大小
  int? fileSize;

  SendMsgDto(Map json) {
    content = json['content'];
    friendId = json['friendId'];
    userId = json['userId'] ?? "";
    messageType = json['messageType'];
    width = json['width'] ?? 0;
    height = json['height'] ?? 0;
    fileName = json['fileName'] ?? "";
    fileSize = json['fileSize'] ?? 0;
    time = DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'friendId': friendId,
      'userId': userId,
      'messageType': messageType,
      'width': width,
      'height': height,
      'time': time,
      'fileName': fileName,
      'fileSize': fileSize,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

/// IM 消息类型
class MessageType {
  /// 文本
  static const String text = 'text';

  /// 图片
  static const String image = 'image';

  /// 文件
  static const String file = 'file';

  /// 语音
  static const String voice = 'voice';

  /// 视频
  static const String video = 'video';

  /// 位置
  static const String location = 'location';

  /// 名片
  static const String card = 'card';

  /// 红包
  static const String redPacket = 'redPacket';

  /// 红包
  static const String transfer = 'transfer';

  /// 红包
  static const String system = 'system';
}
