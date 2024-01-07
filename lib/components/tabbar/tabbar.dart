import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mall_community/common/commStyle.dart';

class TabBare extends StatelessWidget {
  TabBare({
    super.key,
    required this.tabs,
    required this.onTap,
    required this.curr,
  });

  Function(int) onTap;
  final List tabs;
  final int curr;

  tabClick(int i) {
    onTap(i);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.8.sw,
      margin: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: ScreenUtil().bottomBarHeight > 0 ? 20.h : 10.h,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 10),
              blurRadius: 20,
            )
          ]),
      height: 60.h,
      padding: EdgeInsets.only(
        left: 24.w,
        right: 20.w,
        top: 4.h,
      ),
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
                        color: curr == i ? c_ee4c3d : c_333,
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
