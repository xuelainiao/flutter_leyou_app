import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/chat/pages/call_video/controller/call_video_controller.dart';

/// 通话倒计时
class CallTime extends StatefulWidget {
  const CallTime({super.key});

  @override
  State<CallTime> createState() => _CallTimeState();
}

class _CallTimeState extends State<CallTime> {
  CallVideoController callVideoController = Get.find();
  int seconds = 1;
  late Timer time;

  startTime() {
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds += 1;
      });
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  String getTx() {
    Duration d = Duration(seconds: seconds);
    String m = twoDigits(d.inMinutes.remainder(60));
    String s = twoDigits(d.inSeconds.remainder(60));
    String h = twoDigits(d.inHours);
    callVideoController.callTimeTx = "$h:$m:$s";
    return "$h:$m:$s";
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Text(getTx(), style: tx14.copyWith(color: Colors.white));
  }

  @override
  void dispose() {
    time.cancel();
    super.dispose();
  }
}
