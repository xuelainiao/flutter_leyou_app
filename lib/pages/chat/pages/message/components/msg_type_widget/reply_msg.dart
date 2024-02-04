import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/text_span/text_span.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/message_box.dart';

/// 消息回复
class ReplyMsg extends StatelessWidget {
  const ReplyMsg({
    super.key,
    required this.item,
    required this.isMy,
    required this.msgKey,
  });
  final SendMsgDto item;
  final bool isMy;
  final GlobalKey msgKey;

  @override
  Widget build(BuildContext context) {
    QuoteMsgDto quoteMsg = QuoteMsgDto(item.toJson());

    return Column(
      crossAxisAlignment:
          isMy ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          constraints: BoxConstraints(
            minHeight: 40.h,
            maxWidth: 0.6.sw,
          ),
          decoration: BoxDecoration(
            color: isMy ? HexThemColor(primaryColor) : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextSpanEmoji(
            text: quoteMsg.content,
            style: tx14.copyWith(
              color: isMy ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: HexThemColor(cCcc),
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            maxWidth: 0.6.sw,
          ),
          child: replyTheOriginal(quoteMsg.quote),
        )
      ],
    );
  }

  /// 回复消息原文
  Widget replyTheOriginal(SendMsgDto quote) {
    if (quote.messageType == MessageType.text) {
      return TextSpanEmoji(
        text: quote.content,
        style: tx14.copyWith(
          color: isMy ? Colors.white : Colors.black87,
        ),
      );
    } else {
      return MsgTypeWidget(
        item: quote,
        isMy: isMy,
        msgKey: msgKey,
      );
    }
  }
}
