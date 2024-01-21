import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/components/custom_tabs/custom_tabs.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  final List tabs;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.h,
      backgroundColor:
          AppTheme.mode == ThemeMode.dark ? darkColor : Colors.white,
      stretch: true,
      pinned: true,
      floating: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          var offset = constraints.biggest.height / 160;
          return Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: ScreenUtil().statusBarHeight,
                  child: SizedBox(
                    width: 1.sw - 40.w,
                    height: 40.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: Tabs(
                            tabs: tabs,
                            tabController: tabController,
                            labelColor: primaryColor,
                            unselectedLabelColor: primaryNavColor,
                            indicator: const BoxDecoration(),
                            labelStyle: tx20.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon:
                              const Icon(IconData(0xe6cb, fontFamily: 'micon')),
                        ),
                      ],
                    ),
                  ),
                ),
                buildSearch(offset)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSearch(offset) {
    var top = (40.h + ScreenUtil().statusBarHeight) * offset;
    return Positioned(
      top: top,
      child: Opacity(
        opacity: offset > 1 ? 1 : offset - 0.2,
        child: SizedBox(
          width: 1.sw - 40.w,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: BrnSearchText(
              prefixIcon: Container(
                height: 44.h,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(
                  IconData(0xe67e, fontFamily: 'micon'),
                  size: 18,
                  color: Colors.white,
                ),
              ),
              hintText: '搜索用户、群组',
              hintStyle: tx14.copyWith(color: HexThemColor(placeholderTextC)),
              outSideColor: Colors.transparent,
              innerPadding: const EdgeInsets.all(0),
              borderRadius: BorderRadius.circular(10),
              innerColor: HexThemColor(primaryNavColor, direction: -2),
              onTextCommit: (valur) {},
            ),
          ),
        ),
      ),
    );
  }
}
