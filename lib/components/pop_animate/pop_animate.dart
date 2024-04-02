import 'package:flutter/material.dart';

class PopAnimate extends StatefulWidget {
  const PopAnimate({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.alignment = Alignment.topCenter,
    this.isSafeArea = true,
  }) : super(key: key);

  final Widget child;

  /// 动画时长
  final Duration duration;

  /// 动画出现的方向 也可以理解为对齐方向
  final Alignment alignment;

  /// 是否兼容上安全区域 默认为 true
  final bool isSafeArea;

  @override
  State<PopAnimate> createState() => _PopAnimateState();
}

class _PopAnimateState extends State<PopAnimate>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}
