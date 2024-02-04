import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/dto/message_dto.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/toast/toast.dart';

/// 消息工具栏
class MsgToolBar extends StatefulWidget {
  const MsgToolBar({
    super.key,
    required this.msgKey,
    required this.isMy,
    required this.item,
    required this.toolBarKey,
    required this.copyText,
  });

  final GlobalKey msgKey;
  final bool isMy;
  final UniqueKey toolBarKey;
  final SendMsgDto item;
  final Function copyText;

  @override
  State<MsgToolBar> createState() => _MsgToolBarState();
}

class _MsgToolBarState extends State<MsgToolBar> {
  List<Map> list = [
    {'title': '复制', "icon": const IconData(0xe604, fontFamily: 'micon')},
    {'title': '引用', "icon": const IconData(0xe7f6, fontFamily: 'micon')},
    {'title': '撤回', "icon": const IconData(0xe60f, fontFamily: 'micon')},
  ];
  double toolWidth = 170.w;
  double toolHeight = 70.h;

  /// 动画flage
  bool isAnimate = false;

  late Offset offset;
  late Offset arrorOffset;
  late bool isTopHalf;

  copyText() async {
    widget.copyText.call();
  }

  msgQuote() {
    if (widget.item.messageType == MessageType.reply) {
      ToastUtils.showToast('回复消息不支持再次引用', position: 'bottom');
      return;
    }
    ChatController chatC = Get.find();
    chatC.quoteMsg.value = widget.item;
    chatC.showInput();
    OverlayManager().removeOverlay(widget.toolBarKey);
  }

  msgRevoke() {
    print('撤回');
    OverlayManager().removeOverlay(widget.toolBarKey);
  }

  itemClick(String title) {
    switch (title) {
      case "引用":
        msgQuote();
        break;
      case "撤回":
        msgRevoke();
        break;
      default:
        copyText();
    }
  }

  @override
  void initState() {
    final RenderBox box =
        widget.msgKey.currentContext?.findRenderObject() as dynamic;
    final Offset localOffset = box.localToGlobal(Offset.zero);
    //工具栏处于消息的顶部还是底部
    double dy = localOffset.dy;
    isTopHalf = localOffset.dy < 1.sh / 2;
    if (isTopHalf) {
      dy = localOffset.dy + box.size.height + 10.h;
    } else {
      dy = localOffset.dy - (toolHeight + 12.h);
    }
    // 工具栏目左右位置
    double x = localOffset.dx + (box.size.width / 2 - 100.w);
    setState(() {
      offset = Offset(x, dy);
      arrorOffset = Offset(
        localOffset.dx + box.size.width / 2,
        isTopHalf ? dy - 10.h : dy + (toolHeight - 10.h),
      );
    });
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          width: toolWidth,
          height: toolHeight,
          duration: const Duration(milliseconds: 300),
          top: isAnimate ? offset.dy : offset.dy - 10,
          curve: Curves.fastOutSlowIn,
          left: offset.dx,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: routineTextC,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(list.length, (i) => buildItem(i)),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: isAnimate ? arrorOffset.dy : arrorOffset.dy - 10,
          curve: Curves.fastOutSlowIn,
          left: arrorOffset.dx,
          child: CustomPaint(
            size: const Size(20, 20),
            painter: TrianglePainter(isTopHalf),
          ),
        )
      ],
    );
  }

  buildItem(int i) {
    return GestureDetector(
      onTap: () {
        itemClick(list[i]['title']);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(list[i]['icon'], color: Colors.white),
            const SizedBox(height: 4),
            Text(
              list[i]['title'],
              style: tx14.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final bool isUpward;

  TrianglePainter(this.isUpward);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = routineTextC
      ..style = PaintingStyle.fill;

    Path drawPath(double x, double y) {
      if (!isUpward) {
        return Path()
          ..moveTo(x * 0.05, y * 0.1)
          ..quadraticBezierTo(x / 2, -x * 0.10, x * 0.95, y * 0.1)
          ..quadraticBezierTo(x, y * 0.12, x * 0.95, y * 0.2)
          ..lineTo(x * 0.5 + (x * 0.1), y * 0.9)
          ..quadraticBezierTo(x * 0.5, y * 1.08, x * 0.40, y * 0.9)
          ..lineTo(x * 0.05, y * 0.2)
          ..quadraticBezierTo(0, y * 0.12, x * 0.05, y * 0.1)
          ..close();
      } else {
        return Path()
          ..moveTo(x * 0.05, y * 0.9)
          ..quadraticBezierTo(x / 2, y * 1.1, x * 0.95, y * 0.9)
          ..quadraticBezierTo(x, y * 0.88, x * 0.95, y * 0.8)
          ..lineTo(x * 0.5 + (x * 0.1), y * 0.1)
          ..quadraticBezierTo(x * 0.5, -y * 0.08, x * 0.40, y * 0.1)
          ..lineTo(x * 0.05, y * 0.8)
          ..quadraticBezierTo(0, y * 0.88, x * 0.05, y * 0.9)
          ..close();
      }
    }

    canvas.drawPath(drawPath(18, 18), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
