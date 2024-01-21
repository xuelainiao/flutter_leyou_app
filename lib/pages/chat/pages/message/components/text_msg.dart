import 'package:flutter/material.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/text_span/text_span.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';

/// 文本消息
class TextMsg extends StatelessWidget {
  const TextMsg({super.key, required this.msg, required this.isMy});
  final SendMsgDto msg;
  final bool isMy;

  @override
  Widget build(BuildContext context) {
    return TextSpanEmoji(
      text: msg.content,
      style: tx14.copyWith(
        color: isMy ? Colors.white : Colors.black87,
      ),
    );
  }
}
