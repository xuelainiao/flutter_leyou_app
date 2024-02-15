import 'dart:convert';

import 'package:mall_community/pages/chat/controller/chat_controller.dart';

/// Im消息DTO
class SendMsgDto {
  /// 消息体
  late String content;

  /// 好友ID
  late String friendId;

  /// 用户ID
  late String userId;

  /// 发送者用户名
  late String userName;

  /// 消息类型
  late String messageType;

  /// 当前时间戳
  int? time;

  /// 消息状态-前端自己维护不上传-用于消息发送状态效果
  CustomMsgStatus? status;

  SendMsgDto(Map json, {SendMsgDto? quote}) {
    messageType = json['messageType'];
    content =
        json['content'] is Map ? jsonEncode(json['content']) : json['content'];
    if (quote != null) {
      content = jsonEncode({'content': content, 'quote': quote.toJson()});
      messageType = MessageType.reply;
    }
    friendId = json['friendId'];
    userId = json['userId'] ?? "";
    userName = json['userName'] ?? "";
    time = json['time'] ?? DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'friendId': friendId,
      'userId': userId,
      'messageType': messageType,
      'time': time,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

/// 文件消息信息
class FileMsgInfo {
  /// 文件名
  String? fileName;

  /// 文件大小|录音时长
  late int fileSize;

  ///视频封面
  late String cover;

  ///文件内容或者地址
  late String content;

  FileMsgInfo(dynamic json) {
    if (json is String) {
      content = json;
    } else {
      fileName = json['fileName'] ?? "";
      fileSize = json['fileSize'] ?? json['second'] ?? 0;
      content = json['content'] ?? json['url'] ?? '';
      cover = json['cover'] ?? '';
    }
  }

  toJsonString() {
    return jsonEncode({
      'fileName': fileName,
      'fileSize': fileSize,
      'content': content,
      'cover': cover,
    });
  }
}

/// 引用消息DTO
class QuoteMsgDto extends SendMsgDto {
  late SendMsgDto quote;

  QuoteMsgDto(Map json) : super(json) {
    Map textData = jsonDecode(json['content']);
    content = textData['content'] ?? '';
    quote = SendMsgDto(textData['quote']);
    messageType = MessageType.reply;
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['quote'] = quote.toJson();
    return json;
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

  /// 回复
  static const String reply = 'reply';
}
