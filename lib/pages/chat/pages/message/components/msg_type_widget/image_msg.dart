import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';

class ImageMsg extends StatelessWidget {
  const ImageMsg({super.key, required this.isMy, required this.item});

  final SendMsgDto item;
  final bool isMy;

  tap(url) {
    Get.toNamed('/previewImage', arguments: {
      'list': ['$url?time=${item.time}']
    });
  }

  @override
  Widget build(BuildContext context) {
    FileMsgInfo fileMsgInfo = FileMsgInfo(jsonDecode(item.content));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(
        maxWidth: 160.w,
        maxHeight: 246.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          tap(fileMsgInfo.content);
        },
        child: Hero(
          tag: '${fileMsgInfo.content}?time=${item.time}',
          placeholderBuilder: (context, heroSize, child) {
            return child;
          },
          child: NetWorkImg(
            '${fileMsgInfo.content}?time=${item.time}',
            fit: BoxFit.contain,
            raduis: 10,
          ),
        ),
      ),
    );
  }
}
