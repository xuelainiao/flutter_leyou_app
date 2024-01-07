import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputWidget extends StatelessWidget {
  InputWidget({super.key, required this.change});

  Function change;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
      child: Container(
        height: 50.h,
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: InkWell(
                onTap: () {
                  change.call('barrage');
                },
                child: const Icon(IconData(0xe6d1, fontFamily: "psj_font")),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  change.call('input');
                },
                child: Container(
                  height: 36.h,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xfff1f2f3),
                    borderRadius: BorderRadius.circular(36.h),
                  ),
                  child: const Text(
                    '友善评论，切勿伤人心',
                    style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 28,
              width: 28,
              child: InkWell(
                onTap: () {
                  change.call('emoji');
                },
                child: const Icon(IconData(0xe634, fontFamily: "psj_font")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
