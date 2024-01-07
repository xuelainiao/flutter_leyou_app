import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SourceTabs extends StatelessWidget implements PreferredSizeWidget {
  SourceTabs({
    super.key,
    required this.tabs,
    required this.tabController,
    this.change,
    this.labelStyle,
    this.labelColor = Colors.black,
    this.unselectedLabelColor = Colors.black45,
    this.indicatorColor = Colors.red,
    this.isScrollable = true,
    this.labelPadding = 10,
  });

  final List tabs;
  bool isScrollable;
  final TabController tabController;
  Function? change;
  Color labelColor;
  Color indicatorColor;
  Color unselectedLabelColor;
  double labelPadding;
  TextStyle? labelStyle;

  @override
  Size get preferredSize => Size.fromHeight(44.h);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      width: double.maxFinite,
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
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        tabs: tabs.map((e) => Tab(text: e['text'])).toList(),
      ),
    );
  }
}
