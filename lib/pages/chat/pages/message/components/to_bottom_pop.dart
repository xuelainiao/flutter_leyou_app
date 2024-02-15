import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/pop_menu/pop_menu.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';

/// 返回底部弹窗
class ToBottomPop extends StatelessWidget {
  ToBottomPop({super.key});

  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 6),
      child: Obx(
        () => Opacity(
          opacity: chatController.isBottom.value ? 0 : 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  chatController.toBottom(isNext: false);
                  chatController.newMsgNums.value = 0;
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  transform: Matrix4.translationValues(0, 2, 0),
                  decoration: BoxDecoration(
                    color: HexThemColor(chatController.newMsgNums.value > 0
                        ? primaryColor
                        : c999),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: chatController.newMsgNums.value > 0
                      ? Text(
                          "${chatController.newMsgNums.value}",
                          style: tx12.copyWith(color: Colors.white),
                          maxLines: 1,
                        )
                      : const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                        ),
                ),
              ),
              CustomPaint(
                size: const Size(10, 6),
                painter: TrianglePainter(
                  color: HexThemColor(
                    chatController.newMsgNums.value > 0 ? primaryColor : c999,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
