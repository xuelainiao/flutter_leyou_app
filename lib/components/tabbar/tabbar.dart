import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';

class TabBare extends StatelessWidget {
  const TabBare({
    super.key,
    required this.tabs,
    required this.onTap,
    required this.curr,
  });

  final Function(int) onTap;
  final List tabs;
  final int curr;

  tabClick(int i) {
    onTap(i);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.8.sw,
      padding: EdgeInsets.only(
        top: 4.h,
        left: 24.w,
        right: 24.w,
        bottom: ScreenUtil().bottomBarHeight,
      ),
      height: 54.h + ScreenUtil().bottomBarHeight,
      child: IconTheme(
        data: IconThemeData(
          color: Colors.grey.shade400,
          size: 20.sp,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            tabs.length,
            (i) => GestureDetector(
              onTap: () {
                tabClick(i);
              },
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                        height: 34,
                        width: 34,
                        child: curr != i
                            ? tabs[i]['icon']
                            : tabs[i]['activeIcon']),
                    const SizedBox(height: 0),
                    Text(
                      tabs[i]['name'],
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: curr == i ? cEe4c3d : c333,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
