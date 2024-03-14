import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/utils/file_picker/file_picker.dart';
import 'package:mall_community/utils/image_picker/image_picker.dart';
import 'package:mall_community/utils/utils.dart';

/// 聊天底部菜单
class ChatBottomMenu extends StatelessWidget {
  ChatBottomMenu({super.key});
  final ChatController chatController = Get.find();
  final List menus = [
    {
      'title': '相册',
      'icon': const Icon(IconData(0xe7e4, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '拍摄',
      'icon': const Icon(IconData(0xe61b, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '文件',
      'icon': const Icon(IconData(0xe601, fontFamily: 'micon'), size: 34),
    },
    {
      'title': '定位',
      'icon': const Icon(IconData(0xe620, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '视频通话',
      'icon': const Icon(IconData(0xe689, fontFamily: 'micon'), size: 32),
    },
  ];

  itemClick(String name) {
    switch (name) {
      case '拍摄':
        shoot();
        break;
      case '文件':
        filePicker();
        break;
      case '定位':
        location();
        break;
      default:
        imageMsg();
    }
  }

  imageMsg() async {
    List<Map<String, dynamic>> list = [
      {'title': '选择视频', 'type': 'video'},
      {'title': '选择照片', 'type': 'image'}
    ];
    showBottomMenu(list, (Map? item) async {
      if (item == null) return;
      if (item['type'] == 'video') {
        Map? result = await selectVideouploadFile();
        if (result == null) return;
        chatController.sendMsg(
          jsonEncode({'content': result['url'], 'cover': result['cover']}),
          type: MessageType.video,
        );
      } else {
        List cosUrls = await selectImguploadFile();
        if (cosUrls.isEmpty) return;
        for (var item in cosUrls) {
          chatController.sendMsg(
            jsonEncode({'content': item}),
            type: MessageType.image,
          );
        }
      }
    });
  }

  shoot() {
    List<Map<String, dynamic>> list = [
      {'title': '拍摄视频', 'type': 'video'},
      {'title': '拍摄照片', 'type': 'image'}
    ];
    showBottomMenu(list, (Map? item) async {
      if (item == null) return;
      Map? result = await taskPhone(item['type']);
      if (result == null) return;
      chatController.sendMsg(
        jsonEncode({'content': result['url'], 'cover': result['cover']}),
        type: item['type'],
      );
    });
  }

  filePicker() async {
    FileMsgInfo? reuslt = await AppFilePicker.selectFileuploadFile();
    if (reuslt != null) {
      chatController.sendMsg(
        reuslt.toJsonString(),
        type: MessageType.file,
      );
    }
  }

  location() async {
    var result = await Get.toNamed('/map');
    if (result != null) {
      String data = jsonEncode({
        'address': result['address'],
        'name': result['name'],
        'province': result['province'],
        'street': result["street"],
        'district': result["district"],
        "latitude": result["latitude"],
        "longitude": result['longitude'],
        "description": result['description'],
      });
      chatController.sendMsg(data, type: MessageType.location);
    }
  }

  videoCall() async {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 1.sw,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          runSpacing: 20,
          alignment: WrapAlignment.spaceBetween,
          clipBehavior: Clip.hardEdge,
          children: List.generate(menus.length, (i) => buildItem(menus[i])),
        ),
      ),
    );
  }

  Widget buildItem(Map item) {
    return GestureDetector(
      onTap: () {
        itemClick(item['title']);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: HexThemColor(cF1f1f1),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: item['icon'],
          ),
          Text(
            item['title'],
          )
        ],
      ),
    );
  }
}
