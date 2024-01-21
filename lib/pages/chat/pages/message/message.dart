import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/pages/chat/module/chat_module.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input.dart';
import 'package:mall_community/pages/chat/pages/message/components/list.dart';

///好友聊天页面
class MessageListPage extends StatelessWidget {
  MessageListPage({super.key});
  final ChatModule chatModule = Get.put(ChatModule());
  final MsgBotInputModule botInputModule = MsgBotInputModule();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(chatModule.title.value)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.mode == ThemeMode.dark
            ? HexColor("#1c1b1f")
            : Colors.white,
        iconTheme: IconThemeData(
          color:
              AppTheme.mode == ThemeMode.dark ? Colors.white : Colors.black87,
        ),
        titleTextStyle: TextStyle(
          color:
              AppTheme.mode == ThemeMode.dark ? Colors.white : Colors.black87,
        ),
      ),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const MessageList(),
          MsgBotInput(key: MsgBotInputModule.bottomKey),
        ],
      ),
    );
  }
}
