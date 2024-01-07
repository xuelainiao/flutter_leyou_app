import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tabs extends StatelessWidget implements PreferredSizeWidget {
  Tabs({
    super.key,
    required this.tabs,
    required this.tabController,
    this.change,
    this.labelStyle,
    this.labelColor = Colors.black,
    this.unselectedLabelColor = Colors.black45,
    this.isScrollable = true,
    this.labelPadding = 10,
    this.align = TabAlignment.start,
    this.indicatorColor,
    this.unselectedLabelStyle = const TextStyle(fontSize: 14),
    this.indicator,
  });

  final List tabs;

  /// 是否可滚动
  bool isScrollable;

  /// 控制器
  final TabController tabController;

  /// 改变回调
  Function? change;

  /// 文字颜色
  Color labelColor;

  /// 指示器颜色
  final indicatorColor;

  Color unselectedLabelColor;

  /// 文字 padding
  double labelPadding;

  /// 激活文字样式
  TextStyle? labelStyle;

  /// 未激活文字颜色
  TextStyle? unselectedLabelStyle;

  /// 对齐方式
  TabAlignment align;

  /// 指示器样式
  final indicator;

  @override
  Size get preferredSize => Size.fromHeight(44.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: double.maxFinite,
      color: Colors.transparent,
      child: TabBar(
        controller: tabController,
        labelColor: labelColor,
        indicatorColor: indicatorColor,
        unselectedLabelColor: unselectedLabelColor,
        labelPadding: EdgeInsets.symmetric(horizontal: labelPadding),
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: isScrollable,
        labelStyle: labelStyle,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 4),
        unselectedLabelStyle: unselectedLabelStyle,
        tabAlignment: align,
        indicator: indicator,
        dividerColor: Colors.transparent, // 为了去除底部的边框
        tabs: tabs.map((e) => Tab(text: e['text'])).toList(),
      ),
    );
  }
}
