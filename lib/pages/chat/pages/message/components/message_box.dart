import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/Avatar/Avatar.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/pages/chat/pages/message/components/text_msg.dart';

/// 消息 item
class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.item,
    required this.isMy,
    required this.avatar,
  });

  final SendMsgDto item;
  final String avatar;
  final bool isMy;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 40.h),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMy) MyAvatar(src: avatar),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  isMy ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                  child: msgWidget(),
                ),
              ],
            ),
          ),
          if (isMy) MyAvatar(src: avatar)
        ],
      ),
    );
  }

  msgWidget() {
    switch (item.messageType) {
      case 'image':
        break;
      default:
        return TextMsg(msg: item, isMy: isMy);
    }
  }
}
