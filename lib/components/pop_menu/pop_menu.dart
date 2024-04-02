import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/components/pop_animate/pop_animate.dart';

enum _ArrowDirection { top, bottom }

/// 通过 olvery 插入打开
class CustomPopup extends StatefulWidget {
  final GlobalKey? anchorKey;
  final Widget child;
  final bool isLongPress;
  final Color? backgroundColor;
  final Color? arrowColor;
  final Color? barrierColor;
  final bool showArrow;
  final Rect targetRect;

  final Color? barriersColor;

  const CustomPopup({
    super.key,
    required this.child,
    this.anchorKey,
    this.isLongPress = false,
    this.showArrow = true,
    this.backgroundColor,
    this.arrowColor,
    this.barrierColor,
    required this.targetRect,
    this.barriersColor,
  });

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  final GlobalKey _childKey = GlobalKey();
  final GlobalKey _arrowKey = GlobalKey();

  double _maxHeight = _viewportRect.height;
  _ArrowDirection _arrowDirection = _ArrowDirection.top;
  double _arrowHorizontal = 0;
  // double _scaleAlignDx = 0.5;
  // double _scaleAlignDy = 0.5;
  double? _bottom;
  double? _top;
  double? _left;
  double? _right;

  static const double _margin = 10;
  static final Rect _viewportRect = Rect.fromLTWH(
    _margin,
    ScreenUtil().statusBarHeight + _margin,
    1.sw - _margin * 2,
    1.sh -
        ScreenUtil().statusBarHeight -
        ScreenUtil().bottomBarHeight -
        _margin * 2,
  );

  Rect? _getRect(GlobalKey key) {
    final currentContext = key.currentContext;
    final renderBox = currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);
    return offset & renderBox.paintBounds.size;
  }

  // Calculate the horizontal position of the arrow
  void _calculateArrowOffset(Rect? arrowRect, Rect? childRect) {
    if (childRect == null || arrowRect == null) return;
    // Calculate the distance from the left side of the screen based on the middle position of the target and the popover layer
    var leftEdge = widget.targetRect.center.dx - childRect.center.dx;
    final rightEdge = leftEdge + childRect.width;
    leftEdge = leftEdge < _viewportRect.left ? _viewportRect.left : leftEdge;
    // If it exceeds the screen, subtract the excess part
    if (rightEdge > _viewportRect.right) {
      leftEdge -= rightEdge - _viewportRect.right;
    }
    final center = widget.targetRect.center.dx - leftEdge - arrowRect.center.dx;
    // Prevent the arrow from extending beyond the padding of the popover
    if (center + arrowRect.center.dx > childRect.width - 15) {
      _arrowHorizontal = center - 15;
    } else if (center < 15) {
      _arrowHorizontal = 15;
    } else {
      _arrowHorizontal = center;
    }

    // TODO 被动画组件包裹会导致位置偏移 这里根据实际情况自定义
    _arrowHorizontal += 20;

    // _scaleAlignDx = (_arrowHorizontal + arrowRect.center.dx) / childRect.width;
  }

  // Calculate the position of the popover
  void _calculateChildOffset(Rect? childRect) {
    if (childRect == null) return;

    // Calculate the vertical position of the popover
    final topHeight = widget.targetRect.top - _viewportRect.top;
    final bottomHeight = _viewportRect.bottom - widget.targetRect.bottom;
    final maximum = max(topHeight, bottomHeight);
    _maxHeight = childRect.height > maximum ? maximum : childRect.height;
    if (_maxHeight > bottomHeight) {
      // Above the target
      _bottom = 1.sh - widget.targetRect.top;
      _arrowDirection = _ArrowDirection.bottom;
      // _scaleAlignDy = 1;
    } else {
      // Below the target
      _top = widget.targetRect.bottom;
      _arrowDirection = _ArrowDirection.top;
      // _scaleAlignDy = 0;
    }

    // Calculate the vertical position of the popover
    final left = widget.targetRect.center.dx - childRect.center.dx;
    final right = left + childRect.width;
    if (right > _viewportRect.right) {
      // at right
      _right = _margin;
    } else {
      // at left
      // TODO 被动画组件包裹会导致位置偏移 这里根据实际情况自定义
      _left = (left < _margin ? _margin : left) + 20;
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final childRect = _getRect(_childKey);
      final arrowRect = _getRect(_arrowKey);
      _calculateArrowOffset(arrowRect, childRect);
      _calculateChildOffset(childRect);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = PopAnimate(
      child: _PopupContent(
        childKey: _childKey,
        arrowKey: _arrowKey,
        arrowHorizontal: _arrowHorizontal,
        arrowDirection: _arrowDirection,
        backgroundColor: widget.backgroundColor,
        arrowColor: widget.arrowColor,
        showArrow: widget.showArrow,
        child: widget.child,
      ),
    );
    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: Stack(
        children: [
          Positioned(
            left: _left,
            top: _top,
            bottom: _bottom,
            right: _right,
            child: Opacity(
              opacity: _left != null ? 1 : 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _viewportRect.width,
                  maxHeight: _maxHeight,
                ),
                child: child,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _PopupContent extends StatelessWidget {
  final Widget child;
  final GlobalKey childKey;
  final GlobalKey arrowKey;
  final _ArrowDirection arrowDirection;
  final double arrowHorizontal;
  final Color? backgroundColor;
  final Color? arrowColor;
  final bool showArrow;

  const _PopupContent({
    Key? key,
    required this.child,
    required this.childKey,
    required this.arrowKey,
    required this.arrowHorizontal,
    required this.showArrow,
    this.arrowDirection = _ArrowDirection.top,
    this.backgroundColor,
    this.arrowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: childKey,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10).copyWith(
            top: arrowDirection == _ArrowDirection.bottom ? 0 : null,
            bottom: arrowDirection == _ArrowDirection.top ? 0 : null,
          ),
          constraints: const BoxConstraints(minWidth: 50),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: child,
        ),
        Positioned(
          top: arrowDirection == _ArrowDirection.top ? 2 : null,
          bottom: arrowDirection == _ArrowDirection.bottom ? 2 : null,
          left: arrowHorizontal,
          child: RotatedBox(
            key: arrowKey,
            quarterTurns: arrowDirection == _ArrowDirection.top ? 2 : 4,
            child: CustomPaint(
              size: showArrow ? const Size(16, 8) : Size.zero,
              painter: TrianglePainter(
                  color: arrowColor ?? backgroundColor ?? Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  const TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();
    paint.isAntiAlias = true;
    paint.color = color;

    path.lineTo(size.width * 0.66, size.height * 0.86);
    path.cubicTo(size.width * 0.58, size.height * 1.05, size.width * 0.42,
        size.height * 1.05, size.width * 0.34, size.height * 0.86);
    path.cubicTo(size.width * 0.34, size.height * 0.86, 0, 0, 0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width * 0.66, size.height * 0.86,
        size.width * 0.66, size.height * 0.86);
    path.cubicTo(size.width * 0.66, size.height * 0.86, size.width * 0.66,
        size.height * 0.86, size.width * 0.66, size.height * 0.86);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
