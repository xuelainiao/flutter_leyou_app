import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///  全屏任意 widget 拖拽 父级组件必须是 stack
/// 后期也可以扩展范围内拖动
class DragWidget extends StatefulWidget {
  const DragWidget({
    super.key,
    required this.child,
    this.top,
    this.boxSize,
  });

  /// child widget
  final Widget child;

  /// 顶部边界 默认 appbar 高度
  final double? top;

  /// 控件大小 懒得去获取child的大小 见谅 这样也稳定
  /// 默认 Size(100, 200)
  final Size? boxSize;

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  Duration duration = const Duration(milliseconds: 200);
  Size screenSize = const Size(0, 0);
  Size _boxSize = const Size(100, 200);
  Offset positionSize = const Offset(20, 20);
  double _top = 20;
  double centerWidth = 0;

  onPanUpdate(DragUpdateDetails details) {
    double dx = positionSize.dx + details.delta.dx;
    double dy = positionSize.dy + details.delta.dy;
    if (dx < 1) {
      dx = 0;
    } else if (dx + _boxSize.width >= screenSize.width) {
      dx = screenSize.width - _boxSize.width;
    }
    if (dy <= _top) {
      dy = _top;
    } else if (dy + _boxSize.height >= screenSize.height) {
      dy = screenSize.height - _boxSize.height;
    }
    positionSize = Offset(dx, dy);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.boxSize != null) {
      _boxSize = widget.boxSize!;
    }
  }

  @override
  void didChangeDependencies() {
    setState(() {
      screenSize = MediaQuery.of(context).size;
      _top = widget.top ?? positionSize.dy;
      positionSize = Offset(screenSize.width - 20 - _boxSize.width, _top);
      centerWidth = screenSize.width / 2;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      top: positionSize.dy,
      left: positionSize.dx,
      width: _boxSize.width,
      height: _boxSize.height,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            duration = const Duration(milliseconds: 0);
          });
        },
        onPanUpdate: onPanUpdate,
        onPanEnd: (details) {
          double dx = positionSize.dx;
          if (dx > 10 && dx < centerWidth) {
            dx = 10;
          } else if (dx > 10 && dx > centerWidth) {
            dx = screenSize.width - _boxSize.width - 10;
          }
          setState(() {
            duration = const Duration(milliseconds: 300);
            positionSize = Offset(dx, positionSize.dy);
          });
        },
        child: widget.child,
      ),
    );
  }
}
