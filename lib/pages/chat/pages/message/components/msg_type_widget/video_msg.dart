import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/utils/utils.dart';

/// 视频消息
class VideoMsg extends StatelessWidget {
  const VideoMsg({super.key, required this.item, required this.isMy});

  final SendMsgDto item;
  final bool isMy;

  tap(ctx, String url, String cover) {
    previewVideo(ctx, url: url, cover: cover);
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
          tap(context, fileMsgInfo.content, fileMsgInfo.cover);
        },
        child: Hero(
            tag: fileMsgInfo.cover,
            placeholderBuilder: (context, heroSize, child) {
              return child;
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                NetWorkImg(
                  fileMsgInfo.cover,
                  fit: BoxFit.contain,
                  raduis: 10,
                ),
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 60,
                )
              ],
            )),
      ),
    );
  }
}
