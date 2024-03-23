import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/utils/socket/socket_event.dart';

class CallPhoneMsg extends StatelessWidget {
  const CallPhoneMsg({super.key, required this.item, required this.isMy});

  final SendMsgModule item;
  final bool isMy;

  getIcon(String name) {}

  getTx(String status, String time) {
    if (status == SocketEvent.hangUpPhone && time.isEmpty) {
      return isMy ? "通话取消" : "对方已取消";
    }
    switch (status) {
      case SocketEvent.rejectPhone:
        return isMy ? "已拒绝接听" : "对方拒绝接听";
      default:
        return "通话时长：$time";
    }
  }

  @override
  Widget build(BuildContext context) {
    CallVideoMsg msg = CallVideoMsg(jsonDecode(item.content));
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          if (!isMy)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                IconData(0xe621, fontFamily: 'micon'),
                size: 16,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              getTx(msg.status, msg.time),
              style: tx14,
            ),
          ),
          if (isMy)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Transform(
                transform: Matrix4.identity()..rotateY(-pi),
                alignment: Alignment.center,
                child: const Icon(
                  IconData(0xe621, fontFamily: 'micon'),
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
