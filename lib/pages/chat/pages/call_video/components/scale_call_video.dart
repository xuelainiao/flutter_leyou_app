import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/drag_widget/drag_widget.dart';
import 'package:mall_community/pages/chat/pages/call_video/controller/call_video_controller.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/web_rtc/web_rtc_controller.dart';

/// 小屏 缩放播放 webrtc
class ScaleCallVideo extends StatelessWidget {
  const ScaleCallVideo({
    super.key,
    required this.popKey,
    required this.callVideoController,
  });

  final UniqueKey popKey;
  final CallVideoController callVideoController;

  exitScallVideo() {
    OverlayManager().removeOverlay(popKey);
    Get.toNamed("/chat/call_video", arguments: {
      "callVideoController": callVideoController,
    });
  }

  @override
  Widget build(BuildContext context) {
    WebRtcView? view = callVideoController.view;
    WebRtcView? toView = callVideoController.toView;
    return Expanded(
      child: Hero(
        tag: "call_video_page",
        child: Stack(
          children: [
            DragWidget(
              top: ScreenUtil().statusBarHeight + 60,
              child: GestureDetector(
                onTap: exitScallVideo,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      view != null
                          ? RTCVideoView(
                              view.viewRenderer,
                              objectFit: RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                              mirror: true,
                            )
                          : const SizedBox(),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: view != null
                            ? Container(
                                width: 30,
                                height: 50,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: RTCVideoView(
                                  toView!.viewRenderer,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                                  mirror: true,
                                ),
                              )
                            : const SizedBox(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
