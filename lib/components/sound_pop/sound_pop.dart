import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input/waveforms.dart';

/// 录音遮罩弹窗
class SoundPop extends StatelessWidget {
  const SoundPop({super.key, required this.isCancel, required this.second});

  final RxBool isCancel;

  final RxInt second;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      alignment: Alignment.bottomCenter,
      color: Colors.transparent,
      child: Container(
        height: 260,
        width: 1.sw,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.1), Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.1, 0.5, 0.1],
          ),
        ),
        child: Obx(() {
          double size = isCancel.value ? 55 : 50;
          Color bgColor = isCancel.value ? errorColor : backgroundColor;
          Color iconColor = isCancel.value ? Colors.white : routineTextC;
          Color txColor = isCancel.value ? errorColor : routineTextC;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isCancel.value ? '松手取消' : '松手发送，上滑取消',
                style: TextStyle(color: txColor, fontWeight: FontWeight.bold),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: size,
                width: size,
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(top: 14, bottom: 40),
                decoration: BoxDecoration(
                  color: HexThemColor(bgColor),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 30,
                  color: iconColor,
                ),
              ),
              Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: HexThemColor(primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: WaveformsList()),
                      SizedBox(
                        width: 40,
                        child: Obx(() => Text(
                              "${second.value}",
                              style: const TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  )),
              SizedBox(
                height: ScreenUtil().bottomBarHeight + 10,
              )
            ],
          );
        }),
      ),
    );
  }
}
